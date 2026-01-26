# Antigravity Tools Updater

A lightweight, multi-language macOS application that automatically updates [Antigravity Tools](https://github.com/lbjlaq/Antigravity-Manager) to the latest version with a single click.

![Platform](https://img.shields.io/badge/platform-macOS-blue)
![Languages](https://img.shields.io/badge/languages-21-green)
![License](https://img.shields.io/badge/license-MIT-brightgreen)
![Architecture](https://img.shields.io/badge/arch-Apple%20Silicon%20%7C%20Intel-orange)

## Features

- **One-Click Update**: Automatically downloads and installs the latest version
- **Multi-Language Support**: 21 languages with automatic system language detection
- **Universal Binary**: Supports both Apple Silicon (M1/M2/M3) and Intel Macs
- **Smart Detection**: Compares installed version with latest GitHub release
- **Safe Installation**: Removes macOS quarantine flags automatically
- **Persistent Preferences**: Remembers your language choice

## Supported Languages

| Language | Code | Language | Code |
|----------|------|----------|------|
| English | `en` | Nederlands | `nl` |
| Türkçe | `tr` | Polski | `pl` |
| Deutsch | `de` | Svenska | `sv` |
| Français | `fr` | Norsk | `no` |
| Español | `es` | Dansk | `da` |
| Italiano | `it` | Suomi | `fi` |
| Português | `pt` | Українська | `uk` |
| Русский | `ru` | Čeština | `cs` |
| 简体中文 | `zh` | हिन्दी | `hi` |
| 日本語 | `ja` | العربية | `ar` |
| 한국어 | `ko` | | |

## Installation

### Option 1: Download Release (Recommended)

1. Download the latest `Antigravity.Updater.zip` from [Releases](../../releases)
2. Extract and move `Antigravity Updater.app` to your Applications folder
3. Double-click to run

### Option 2: Run Script Directly

```bash
git clone https://github.com/ercanatay/AntigravityUpdater.git
cd AntigravityUpdater
chmod +x antigravity-update.sh
./antigravity-update.sh
```

## Usage

### First Run
On first launch, you'll see a language selection menu:

```
╔══════════════════════════════════════════════════════════╗
║     🌍 Select Language / Dil Seçin / 选择语言            ║
╚══════════════════════════════════════════════════════════╝

   1) Türkçe        8) Русский      15) Svenska
   2) English       9) 简体中文      16) Norsk
   3) Deutsch      10) 日本語       17) Dansk
   ...

   0) Auto-detect / Otomatik

➤
```

### Subsequent Runs
The updater remembers your language preference and proceeds directly to update checking.

### Command Line Options

```bash
# Change language
./antigravity-update.sh --lang
./antigravity-update.sh -l

# Reset language preference
./antigravity-update.sh --reset-lang
```

## How It Works

1. **Version Check**: Reads current installed version from app bundle
2. **GitHub API**: Fetches latest release information
3. **Download**: Downloads appropriate DMG for your architecture
4. **Install**: Mounts DMG, copies app to /Applications
5. **Cleanup**: Removes quarantine flags and temporary files

## Project Structure

```
AntigravityUpdater/
├── Antigravity Updater.app/    # macOS application bundle
├── antigravity-update.sh       # Main updater script
├── locales/                    # Language files
│   ├── en.sh                   # English (default)
│   ├── tr.sh                   # Turkish
│   ├── de.sh                   # German
│   └── ...                     # 18 more languages
├── README.md
└── LICENSE
```

## Building the App Bundle

The `.app` bundle is a wrapper that runs the shell script in Terminal:

```
Antigravity Updater.app/
├── Contents/
│   ├── Info.plist
│   ├── MacOS/
│   │   └── launcher           # Executable wrapper
│   └── Resources/
│       ├── antigravity-update.sh
│       └── locales/
```

## Requirements

- macOS 10.15 (Catalina) or later
- Internet connection
- `/Applications` write permission

## Troubleshooting

### "App is damaged and can't be opened"
Run this command to remove quarantine:
```bash
xattr -cr /path/to/Antigravity\ Updater.app
```

### Permission Denied
Ensure the script is executable:
```bash
chmod +x antigravity-update.sh
```

### GitHub API Rate Limit
If you see API errors, wait a few minutes and try again. GitHub limits unauthenticated requests.

## Contributing

Contributions are welcome! To add a new language:

1. Copy `locales/en.sh` to `locales/[lang-code].sh`
2. Translate all `MSG_*` variables
3. Update `LANG_CODES` and `LANG_NAMES` arrays in main script
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Antigravity Tools](https://github.com/lbjlaq/Antigravity-Manager) - The application this updater supports
- All contributors who helped with translations

## Author

**Ercan ATAY**
- GitHub: [@ercanatay](https://github.com/ercanatay)
- Website: [ercanatay.com](https://www.ercanatay.com/en/)

---

Made with ❤️ for the Antigravity Tools community
