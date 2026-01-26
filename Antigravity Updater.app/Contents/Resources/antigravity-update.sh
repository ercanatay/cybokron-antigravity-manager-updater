#!/bin/bash

# Antigravity Tools Updater
# Tek tıkla en son sürümü indirir ve kurar

set -e

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Ayarlar
REPO_OWNER="lbjlaq"
REPO_NAME="Antigravity-Manager"
APP_NAME="Antigravity Tools"
APP_PATH="/Applications/Antigravity Tools.app"
TEMP_DIR=$(mktemp -d)

# Mimari tespiti
if [[ $(uname -m) == "arm64" ]]; then
    ARCH="aarch64"
    ARCH_NAME="Apple Silicon"
else
    ARCH="universal"
    ARCH_NAME="Intel"
fi

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         🚀 Antigravity Tools Updater                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Mevcut sürümü kontrol et
echo -e "${BLUE}📦 Mevcut sürüm kontrol ediliyor...${NC}"
if [[ -d "$APP_PATH" ]]; then
    CURRENT_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist" 2>/dev/null || echo "Bilinmiyor")
    echo -e "   Mevcut: ${GREEN}$CURRENT_VERSION${NC}"
else
    CURRENT_VERSION="Yüklü değil"
    echo -e "   Mevcut: ${YELLOW}$CURRENT_VERSION${NC}"
fi

# GitHub'dan son sürümü al
echo -e "${BLUE}🌐 Son sürüm kontrol ediliyor...${NC}"
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")

if [[ -z "$RELEASE_INFO" ]] || [[ "$RELEASE_INFO" == *"rate limit"* ]]; then
    echo -e "${RED}❌ GitHub API'ye erişilemedi${NC}"
    exit 1
fi

LATEST_VERSION=$(echo "$RELEASE_INFO" | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')
echo -e "   Son:    ${GREEN}$LATEST_VERSION${NC}"
echo -e "   Mimari: ${CYAN}$ARCH_NAME ($ARCH)${NC}"

# Güncelleme gerekli mi?
if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo ""
    echo -e "${GREEN}✅ Zaten en güncel sürümdesiniz!${NC}"
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo ""
echo -e "${YELLOW}📥 Yeni sürüm mevcut! İndirme başlatılıyor...${NC}"

# DMG dosyasını indir
DMG_NAME="Antigravity.Tools_${LATEST_VERSION}_${ARCH}.dmg"
DOWNLOAD_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/v$LATEST_VERSION/$DMG_NAME"
DMG_PATH="$TEMP_DIR/$DMG_NAME"

echo -e "${BLUE}⬇️  DMG indiriliyor...${NC}"
echo "   $DOWNLOAD_URL"

if ! curl -L --progress-bar -o "$DMG_PATH" "$DOWNLOAD_URL"; then
    echo -e "${RED}❌ İndirme başarısız!${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ İndirme tamamlandı${NC}"

# DMG'yi bağla
echo -e "${BLUE}💿 DMG bağlanıyor...${NC}"
MOUNT_OUTPUT=$(hdiutil attach "$DMG_PATH" -nobrowse -quiet 2>&1)
MOUNT_POINT=$(echo "$MOUNT_OUTPUT" | grep "Volumes" | awk '{print $NF}')

if [[ -z "$MOUNT_POINT" ]]; then
    # Alternatif mount point bulma
    MOUNT_POINT=$(ls -d /Volumes/*Antigravity* 2>/dev/null | head -1)
fi

if [[ -z "$MOUNT_POINT" ]] || [[ ! -d "$MOUNT_POINT" ]]; then
    echo -e "${RED}❌ DMG bağlanamadı${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ DMG bağlandı: $MOUNT_POINT${NC}"

# Eski uygulamayı kapat
echo -e "${BLUE}🔄 Mevcut uygulama kapatılıyor...${NC}"
pkill -f "$APP_NAME" 2>/dev/null || true
sleep 1

# Eski uygulamayı sil
if [[ -d "$APP_PATH" ]]; then
    echo -e "${BLUE}🗑️  Eski sürüm kaldırılıyor...${NC}"
    rm -rf "$APP_PATH"
fi

# Yeni uygulamayı kopyala
echo -e "${BLUE}📁 Yeni sürüm kopyalanıyor...${NC}"
SOURCE_APP="$MOUNT_POINT/$APP_NAME.app"

if [[ ! -d "$SOURCE_APP" ]]; then
    # Farklı isimle dene
    SOURCE_APP=$(find "$MOUNT_POINT" -maxdepth 1 -name "*.app" | head -1)
fi

if [[ -z "$SOURCE_APP" ]] || [[ ! -d "$SOURCE_APP" ]]; then
    echo -e "${RED}❌ Uygulama DMG içinde bulunamadı${NC}"
    hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
    rm -rf "$TEMP_DIR"
    exit 1
fi

cp -R "$SOURCE_APP" "$APP_PATH"
echo -e "${GREEN}✅ Uygulama kopyalandı${NC}"

# Karantina özelliğini kaldır
echo -e "${BLUE}🔓 Karantina kaldırılıyor (xattr -cr)...${NC}"
xattr -cr "$APP_PATH"
echo -e "${GREEN}✅ Karantina kaldırıldı${NC}"

# DMG'yi ayır
echo -e "${BLUE}💿 DMG ayrılıyor...${NC}"
hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true

# Temizlik
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         ✅ GÜNCELLEME BAŞARIYLA TAMAMLANDI!              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "   Eski sürüm: ${YELLOW}$CURRENT_VERSION${NC}"
echo -e "   Yeni sürüm: ${GREEN}$LATEST_VERSION${NC}"
echo ""

# Uygulamayı otomatik aç (isteğe bağlı - kullanıcı isterse bu satırı silebilir)
# Açılmasını istemiyorsanız, aşağıdaki satırları # ile başlatarak devre dışı bırakın
# open "$APP_PATH"
# echo -e "${GREEN}🚀 Uygulama açılıyor...${NC}"
