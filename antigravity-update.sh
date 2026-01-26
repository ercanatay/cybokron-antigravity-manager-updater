#!/bin/bash

# Antigravity Tools Updater - Multi-Language Version
# Supports 20 languages with automatic system language detection

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Settings
REPO_OWNER="lbjlaq"
REPO_NAME="Antigravity-Manager"
APP_NAME="Antigravity Tools"
APP_PATH="/Applications/Antigravity Tools.app"
TEMP_DIR=$(mktemp -d)

# Script directory detection
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCALES_DIR="$SCRIPT_DIR/locales"

# If running from .app bundle, adjust path
if [[ "$SCRIPT_DIR" == *".app/Contents/Resources"* ]]; then
    LOCALES_DIR="$SCRIPT_DIR/locales"
fi

# Available languages
declare -a LANG_CODES=("tr" "en" "de" "fr" "es" "it" "pt" "ru" "zh" "ja" "ko" "ar" "nl" "pl" "sv" "no" "da" "fi" "uk" "cs" "hi")
declare -a LANG_NAMES=("Türkçe" "English" "Deutsch" "Français" "Español" "Italiano" "Português" "Русский" "简体中文" "日本語" "한국어" "العربية" "Nederlands" "Polski" "Svenska" "Norsk" "Dansk" "Suomi" "Українська" "Čeština" "हिन्दी")

# Language preference file
LANG_PREF_FILE="$HOME/.antigravity_updater_lang"

# Load language file
load_language() {
    local lang_code="$1"
    local lang_file="$LOCALES_DIR/${lang_code}.sh"

    if [[ -f "$lang_file" ]]; then
        source "$lang_file"
        return 0
    else
        # Fallback to English
        if [[ -f "$LOCALES_DIR/en.sh" ]]; then
            source "$LOCALES_DIR/en.sh"
            return 0
        fi
    fi
    return 1
}

# Detect system language
detect_system_language() {
    local sys_lang=""

    # Try to get macOS system language
    if command -v defaults &> /dev/null; then
        sys_lang=$(defaults read -g AppleLocale 2>/dev/null | cut -d'_' -f1 || echo "")
    fi

    # Fallback to LANG environment variable
    if [[ -z "$sys_lang" ]]; then
        sys_lang=$(echo "$LANG" | cut -d'_' -f1 | cut -d'.' -f1)
    fi

    # Check if we support this language
    for code in "${LANG_CODES[@]}"; do
        if [[ "$code" == "$sys_lang" ]]; then
            echo "$sys_lang"
            return 0
        fi
    done

    # Default to English
    echo "en"
}

# Show language selection menu
show_language_menu() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║     🌍 Select Language / Dil Seçin / 选择语言            ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""

    local cols=3
    local count=${#LANG_CODES[@]}
    local rows=$(( (count + cols - 1) / cols ))

    for ((i=0; i<rows; i++)); do
        for ((j=0; j<cols; j++)); do
            local idx=$((i + j * rows))
            if [[ $idx -lt $count ]]; then
                printf "  ${YELLOW}%2d)${NC} %-12s" $((idx + 1)) "${LANG_NAMES[$idx]}"
            fi
        done
        echo ""
    done

    echo ""
    echo -e "  ${MAGENTA} 0)${NC} Auto-detect / Otomatik"
    echo ""
    echo -n -e "${CYAN}➤ ${NC}"
    read -r choice

    if [[ "$choice" == "0" ]]; then
        SELECTED_LANG=$(detect_system_language)
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le "$count" ]]; then
        SELECTED_LANG="${LANG_CODES[$((choice - 1))]}"
    else
        SELECTED_LANG="en"
    fi

    # Save preference
    echo "$SELECTED_LANG" > "$LANG_PREF_FILE"

    load_language "$SELECTED_LANG"
}

# Check for saved language preference
check_language_preference() {
    if [[ -f "$LANG_PREF_FILE" ]]; then
        local saved_lang
        saved_lang=$(cat "$LANG_PREF_FILE")
        if load_language "$saved_lang"; then
            SELECTED_LANG="$saved_lang"
            return 0
        fi
    fi
    return 1
}

# Architecture detection
if [[ $(uname -m) == "arm64" ]]; then
    ARCH="aarch64"
    ARCH_NAME="Apple Silicon"
else
    ARCH="universal"
    ARCH_NAME="Intel"
fi

# Main execution starts here

# Check for --lang flag or show menu
if [[ "$1" == "--lang" ]] || [[ "$1" == "-l" ]]; then
    show_language_menu
elif [[ "$1" == "--reset-lang" ]]; then
    rm -f "$LANG_PREF_FILE"
    show_language_menu
elif ! check_language_preference; then
    # First run - show language selection
    show_language_menu
fi

# Clear screen for main display
clear

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         $MSG_TITLE"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Show current language
echo -e "   ${MAGENTA}🌐 $LANG_NAME${NC} (--lang to change)"
echo ""

# Check current version
echo -e "${BLUE}$MSG_CHECKING_VERSION${NC}"
if [[ -d "$APP_PATH" ]]; then
    CURRENT_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist" 2>/dev/null || echo "$MSG_UNKNOWN")
    echo -e "   $MSG_CURRENT: ${GREEN}$CURRENT_VERSION${NC}"
else
    CURRENT_VERSION="$MSG_NOT_INSTALLED"
    echo -e "   $MSG_CURRENT: ${YELLOW}$CURRENT_VERSION${NC}"
fi

# Get latest version from GitHub
echo -e "${BLUE}$MSG_CHECKING_LATEST${NC}"
RELEASE_INFO=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest")

if [[ -z "$RELEASE_INFO" ]] || [[ "$RELEASE_INFO" == *"rate limit"* ]]; then
    echo -e "${RED}$MSG_API_ERROR${NC}"
    exit 1
fi

LATEST_VERSION=$(echo "$RELEASE_INFO" | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')
echo -e "   $MSG_LATEST:    ${GREEN}$LATEST_VERSION${NC}"
echo -e "   $MSG_ARCH: ${CYAN}$ARCH_NAME ($ARCH)${NC}"

# Check if update is needed
if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    echo ""
    echo -e "${GREEN}$MSG_ALREADY_LATEST${NC}"
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo ""
echo -e "${YELLOW}$MSG_NEW_VERSION${NC}"

# Download DMG
DMG_NAME="Antigravity.Tools_${LATEST_VERSION}_${ARCH}.dmg"
DOWNLOAD_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/v$LATEST_VERSION/$DMG_NAME"
DMG_PATH="$TEMP_DIR/$DMG_NAME"

echo -e "${BLUE}$MSG_DOWNLOADING${NC}"
echo "   $DOWNLOAD_URL"

if ! curl -L --progress-bar -o "$DMG_PATH" "$DOWNLOAD_URL"; then
    echo -e "${RED}$MSG_DOWNLOAD_FAILED${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}$MSG_DOWNLOAD_COMPLETE${NC}"

# Mount DMG
echo -e "${BLUE}$MSG_MOUNTING${NC}"
MOUNT_OUTPUT=$(hdiutil attach "$DMG_PATH" -nobrowse -quiet 2>&1)
MOUNT_POINT=$(echo "$MOUNT_OUTPUT" | grep "Volumes" | awk '{print $NF}')

if [[ -z "$MOUNT_POINT" ]]; then
    MOUNT_POINT=$(ls -d /Volumes/*Antigravity* 2>/dev/null | head -1)
fi

if [[ -z "$MOUNT_POINT" ]] || [[ ! -d "$MOUNT_POINT" ]]; then
    echo -e "${RED}$MSG_MOUNT_FAILED${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}$MSG_MOUNTED: $MOUNT_POINT${NC}"

# Close running application
echo -e "${BLUE}$MSG_CLOSING_APP${NC}"
pkill -f "$APP_NAME" 2>/dev/null || true
sleep 1

# Remove old version
if [[ -d "$APP_PATH" ]]; then
    echo -e "${BLUE}$MSG_REMOVING_OLD${NC}"
    rm -rf "$APP_PATH"
fi

# Copy new version
echo -e "${BLUE}$MSG_COPYING_NEW${NC}"
SOURCE_APP="$MOUNT_POINT/$APP_NAME.app"

if [[ ! -d "$SOURCE_APP" ]]; then
    SOURCE_APP=$(find "$MOUNT_POINT" -maxdepth 1 -name "*.app" | head -1)
fi

if [[ -z "$SOURCE_APP" ]] || [[ ! -d "$SOURCE_APP" ]]; then
    echo -e "${RED}$MSG_APP_NOT_FOUND${NC}"
    hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
    rm -rf "$TEMP_DIR"
    exit 1
fi

cp -R "$SOURCE_APP" "$APP_PATH"
echo -e "${GREEN}$MSG_COPIED${NC}"

# Remove quarantine
echo -e "${BLUE}$MSG_REMOVING_QUARANTINE${NC}"
xattr -cr "$APP_PATH"
echo -e "${GREEN}$MSG_QUARANTINE_REMOVED${NC}"

# Unmount DMG
echo -e "${BLUE}$MSG_UNMOUNTING${NC}"
hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         $MSG_UPDATE_SUCCESS${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "   $MSG_OLD_VERSION: ${YELLOW}$CURRENT_VERSION${NC}"
echo -e "   $MSG_NEW_VERSION_LABEL: ${GREEN}$LATEST_VERSION${NC}"
echo ""
