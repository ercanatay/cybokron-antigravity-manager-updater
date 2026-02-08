# Antigravity Tools Updater

[Antigravity Tools](https://github.com/lbjlaq/Antigravity-Manager) için macOS, Windows, Linux ve Docker ortamlarında çalışan resmi olmayan güncelleme betikleri.

> Bu depo **Antigravity Tools uygulamasını içermez**. Yalnızca güncelleyici (updater) araçlarını içerir.

![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Docker-blue)
![Updater Release](https://img.shields.io/badge/updater-1.4.3-green)
![Languages](https://img.shields.io/badge/languages-51-orange)
![License](https://img.shields.io/badge/license-MIT-brightgreen)

## İçindekiler

- [Ne İşe Yarar?](#ne-işe-yarar)
- [Sürüm ve Yayınlar](#sürüm-ve-yayınlar)
- [Hangi Güncelleyiciyi Kullanmalıyım?](#hangi-güncelleyiciyi-kullanmalıyım)
- [Özellik Matrisi](#özellik-matrisi)
- [Hızlı Başlangıç](#hızlı-başlangıç)
- [Gereksinimler](#gereksinimler)
- [Komut Referansı](#komut-referansı)
- [Sık Kullanılan Senaryolar](#sık-kullanılan-senaryolar)
- [Dil Desteği (51 Dil)](#dil-desteği-51-dil)
- [Log Dosyaları](#log-dosyaları)
- [Sorun Giderme](#sorun-giderme)
- [Güvenlik Notları](#güvenlik-notları)
- [Depo Yapısı](#depo-yapısı)
- [Katkı](#katkı)
- [Lisans](#lisans)

## Ne İşe Yarar?

Bu depodaki güncelleyiciler:

1. `lbjlaq/Antigravity-Manager` deposundaki en güncel sürümü kontrol eder.
2. Mevcut kurulu sürüm ile karşılaştırır.
3. Platforma uygun şekilde indirip günceller.

## Sürüm ve Yayınlar

- Bu depo (updater) yayınları: https://github.com/ercanatay/AntigravityUpdater/releases
- Ana uygulama (upstream) yayınları: https://github.com/lbjlaq/Antigravity-Manager/releases

> **Not:** Bir PR merge edilmesi sadece kodu günceller. İndirilebilir updater sürümü yayınlamak için ayrıca `vX.Y.Z` etiketi ile GitHub Release oluşturulmalıdır.

## Hangi Güncelleyiciyi Kullanmalıyım?

| Hedef | Komut | Güncellediği şey |
|---|---|---|
| macOS uygulama kurulumu | `./antigravity-update.sh` | `/Applications/Antigravity Tools.app` |
| Windows uygulama kurulumu | `./windows/antigravity-update.ps1` (veya `./windows/AntigravityUpdater.bat`) | Yerel Antigravity Tools kurulumu |
| Linux uygulama kurulumu | `./linux/antigravity-update.sh` | `.deb`, `.rpm` veya `.AppImage` kurulumu |
| Docker dağıtımı | `./docker/antigravity-docker-update.sh` | Docker image/tag güncellemesi ve isteğe bağlı container yeniden oluşturma |

## Özellik Matrisi

| Özellik | macOS | Windows | Linux | Docker |
|---|---|---|---|---|
| 51 dil arayüzü | ✅ | ✅ | ✅ | ✅ |
| Otomatik dil algılama | ✅ | ✅ | ✅ | ✅ |
| Sadece kontrol modu | ✅ | ✅ | ✅ | ✅ |
| Proxy desteği | ✅ | ✅ | ✅ | ✅ |
| Sessiz mod | ✅ | ✅ | ✅ | ✅ |
| Changelog gösterimi | ✅ | ✅ | ✅ | ✅ |
| Güncelleme öncesi yedek | ✅ | ✅ | ❌ | ❌ |
| Rollback | ✅ | ✅ | ❌ | ❌ |
| Paket tipi seçimi | ❌ | ❌ | ✅ | ❌ |
| Çalışan süreci yeniden başlatma | Uygulama yeniden açılır | Uygulama yeniden açılır | Süreç sonlandırılır | İsteğe bağlı container recreate |

## Hızlı Başlangıç

### macOS

```bash
git clone https://github.com/ercanatay/AntigravityUpdater.git
cd AntigravityUpdater
chmod +x antigravity-update.sh
./antigravity-update.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/ercanatay/AntigravityUpdater.git
cd AntigravityUpdater\windows
powershell -ExecutionPolicy Bypass -File .\antigravity-update.ps1
```

Alternatif başlatıcı:

```powershell
.\AntigravityUpdater.bat
```

### Linux

```bash
git clone https://github.com/ercanatay/AntigravityUpdater.git
cd AntigravityUpdater/linux
chmod +x antigravity-update.sh
./antigravity-update.sh
```

### Docker

```bash
git clone https://github.com/ercanatay/AntigravityUpdater.git
cd AntigravityUpdater
chmod +x docker/antigravity-docker-update.sh
./docker/antigravity-docker-update.sh --check-only
```

## Gereksinimler

### macOS

- macOS 10.15+
- `curl`
- Güncelleme kontrolü için `python3`
- `/Applications` altında yazma izni

### Windows

- Windows 10/11 (64-bit)
- PowerShell 5.1+
- İnternet erişimi

### Linux

- Bash
- `curl`
- `python3`
- Kurulum için:
  - `.deb`: `apt-get`/`dpkg`
  - `.rpm`: `dnf`, `yum`, `zypper` veya `rpm`
  - `.AppImage`: Paket yöneticisi gerekmez

### Docker güncelleyici

- `curl`
- `python3`
- Docker CLI (pull/restart için gerekli)

> `--check-only` kullanımı Docker kurulu olmasa da en güncel hedef image bilgisini gösterebilir.

## Komut Referansı

### macOS: `antigravity-update.sh`

```text
--lang, -l          Dil seçimi
--reset-lang        Kayıtlı dil tercihini sıfırla
--check-only        Sadece güncelleme kontrolü yap
--changelog         Güncellemeden önce sürüm notlarını göster
--rollback          Son yedekten geri dön
--silent            Etkileşimi en aza indir
--no-backup         Güncelleme öncesi yedek almayı atla
--proxy URL         HTTP(S) proxy kullan
--help, -h          Yardımı göster
```

### Windows: `windows/antigravity-update.ps1`

```text
-Lang               Dil seçimi
-ResetLang          Kayıtlı dil tercihini sıfırla
-SetLang <code>     Dili doğrudan ayarla (ör. tr, en, de)
-CheckOnly          Sadece güncelleme kontrolü yap
-ShowChangelog      Güncellemeden önce sürüm notlarını göster
-Rollback           Son yedekten geri dön
-Silent             Etkileşimi en aza indir
-NoBackup           Güncelleme öncesi yedek almayı atla
-ProxyUrl <url>     Proxy kullan
-Help               Yardımı göster
```

### Linux: `linux/antigravity-update.sh`

```text
--lang, -l          Dil seçimi
--reset-lang        Kayıtlı dil tercihini sıfırla
--check-only        Sadece güncelleme kontrolü yap
--changelog         Güncellemeden önce sürüm notlarını göster
--silent            Etkileşimi en aza indir
--proxy URL         HTTP(S) proxy kullan
--format TYPE       auto | deb | rpm | appimage
--help, -h          Yardımı göster
```

### Docker: `docker/antigravity-docker-update.sh`

```text
--lang, -l                   Dil seçimi
--reset-lang                 Kayıtlı dil tercihini sıfırla
--check-only                 Sadece durum/güncelleme kontrolü
--changelog                  Image çekmeden önce sürüm notlarını göster
--restart-container          Mevcut container'ı yeni image ile yeniden oluştur
--container-name NAME        Container adı (varsayılan: antigravity-manager)
--image REPO                 Docker image deposu (varsayılan: lbjlaq/antigravity-manager)
--tag TAG                    Hedef tag'i elle belirle (varsayılan: en güncel release tag)
--proxy URL                  GitHub API istekleri için proxy
--silent                     Etkileşimi en aza indir
--help, -h                   Yardımı göster
```

## Sık Kullanılan Senaryolar

### Tüm platformlarda sadece kontrol

```bash
./antigravity-update.sh --check-only
./linux/antigravity-update.sh --check-only
./docker/antigravity-docker-update.sh --check-only
```

```powershell
.\windows\antigravity-update.ps1 -CheckOnly
```

### Linux'ta paket türünü zorlamak

```bash
./linux/antigravity-update.sh --format deb
./linux/antigravity-update.sh --format rpm
./linux/antigravity-update.sh --format appimage
```

### Dil değiştirmek

```bash
./antigravity-update.sh --lang
./linux/antigravity-update.sh --lang
./docker/antigravity-docker-update.sh --lang
```

```powershell
.\windows\antigravity-update.ps1 -Lang
.\windows\antigravity-update.ps1 -SetLang tr
```

### Docker image güncelle + container yeniden başlat

```bash
./docker/antigravity-docker-update.sh --restart-container --container-name antigravity-manager
```

## Dil Desteği (51 Dil)

Desteklenen dil kodları:

`en, tr, de, fr, es, it, pt, ru, zh, zh-TW, ja, ko, ar, nl, pl, sv, no, da, fi, uk, cs, hi, el, he, th, vi, id, ms, hu, ro, bg, hr, sr, sk, sl, lt, lv, et, ca, eu, gl, is, fa, sw, af, fil, bn, ta, ur, mi, cy`

Dil tercihi dosyaları:

- macOS: `~/.antigravity_updater_lang`
- Windows: `%APPDATA%\antigravity_updater_lang.txt`
- Linux: `~/.antigravity_updater_lang_linux`
- Docker: `~/.antigravity_updater_lang_docker`

## Log Dosyaları

- macOS: `~/Library/Application Support/AntigravityUpdater/updater.log`
- Windows: `%APPDATA%\AntigravityUpdater\updater.log`
- Linux: `$XDG_STATE_HOME/AntigravityUpdater/updater.log` (fallback: `~/.local/state/AntigravityUpdater/updater.log`)
- Docker: `$XDG_STATE_HOME/AntigravityUpdater/docker-updater.log` (fallback: `~/.local/state/AntigravityUpdater/docker-updater.log`)

## Sorun Giderme

### 1) GitHub API rate limit

Kimlik doğrulamasız GitHub API kullanımında limit düşüktür (genellikle IP başına saatte 60 istek).
Bir süre bekleyip tekrar deneyin.

### 2) Linux kurulumunda yetki hatası

`.deb` / `.rpm` kurulumunda `sudo` yetkili kullanıcı ile çalıştırın.

### 3) Linux paket yöneticisi bulunamıyor

AppImage modunu kullanın:

```bash
./linux/antigravity-update.sh --format appimage
```

### 4) Docker kurulumu compose ile yönetiliyor

`--restart-container` seçeneği daha çok `docker run` ile açılan container'lar içindir.
Compose için ilgili dizinde şunları çalıştırın:

```bash
docker compose pull
docker compose up -d
```

### 5) Windows execution policy script'i engelliyor

```powershell
powershell -ExecutionPolicy Bypass -File .\windows\antigravity-update.ps1
```

### 6) macOS'ta çalıştırma izni hatası

```bash
chmod +x antigravity-update.sh
```

## Güvenlik Notları

Mevcut sürümde özellikle macOS tarafında güvenlik sertleştirmeleri bulunur:

- DMG içindeki kaynak uygulamada kurulum öncesi code-signature doğrulaması
- Beklenen `CFBundleIdentifier` kontrolü
- Symlink kaynak uygulama reddi
- `cp -R` yerine `ditto` ile daha güvenli kopyalama/geri alma
- Geçici dosya ve log yönetiminde ek sağlamlaştırmalar

Detaylı güvenlik geçmişi için `CHANGELOG.md` dosyasına bakın.

## Depo Yapısı

```text
AntigravityUpdater/
├── antigravity-update.sh                # macOS güncelleyici
├── locales/                             # Ortak locale dosyaları (.sh)
├── windows/
│   ├── antigravity-update.ps1           # Windows güncelleyici
│   ├── AntigravityUpdater.bat           # Windows başlatıcı
│   └── locales/                         # Windows locale dosyaları (.ps1)
├── linux/
│   └── antigravity-update.sh            # Linux güncelleyici
├── docker/
│   └── antigravity-docker-update.sh     # Docker güncelleyici
├── CHANGELOG.md
└── README.md
```

## Katkı

- Hata düzeltmesi/iyileştirme için issue veya PR açabilirsiniz.
- Çeviri katkılarında ilgili locale dosyalarını güncellerken anahtar adlarının tutarlı kalmasına dikkat edin.

## Lisans

MIT. Detaylar için `LICENSE` dosyasına bakın.
