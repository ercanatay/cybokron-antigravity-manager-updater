# Contributing to Antigravity Tools Updater

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## How to Contribute

### Adding a New Language

1. **Create language file**
   ```bash
   cp locales/en.sh locales/[your-lang-code].sh
   ```

2. **Translate all messages**
   Edit the new file and translate all `MSG_*` variables:
   ```bash
   LANG_NAME="Your Language Name"
   LANG_CODE="xx"

   MSG_TITLE="🚀 Antigravity Tools Updater"
   MSG_CHECKING_VERSION="📦 Checking current version..."
   # ... translate all other messages
   ```

3. **Update main script**
   Add your language to the arrays in `antigravity-update.sh`:
   ```bash
   declare -a LANG_CODES=("tr" "en" ... "xx")
   declare -a LANG_NAMES=("Türkçe" "English" ... "Your Language")
   ```

4. **Test your translation**
   ```bash
   ./antigravity-update.sh --reset-lang
   ```

5. **Submit a pull request**

### Reporting Bugs

- Use GitHub Issues
- Include macOS version
- Include error messages
- Describe steps to reproduce

### Suggesting Features

- Open an issue with `[Feature]` prefix
- Describe the use case
- Explain expected behavior

## Code Style

- Use 4 spaces for indentation
- Keep lines under 100 characters
- Add comments for complex logic
- Follow existing patterns

## Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit PR with clear description

## Language File Template

```bash
# [Language Name] ([Native Name])
LANG_NAME="Native Name"
LANG_CODE="xx"

MSG_TITLE="🚀 Antigravity Tools Updater"
MSG_CHECKING_VERSION="📦 Checking current version..."
MSG_CURRENT="Current"
MSG_NOT_INSTALLED="Not installed"
MSG_UNKNOWN="Unknown"
MSG_CHECKING_LATEST="🌐 Checking latest version..."
MSG_LATEST="Latest"
MSG_ARCH="Architecture"
MSG_ALREADY_LATEST="✅ You already have the latest version!"
MSG_NEW_VERSION="📥 New version available! Starting download..."
MSG_DOWNLOADING="⬇️  Downloading DMG..."
MSG_DOWNLOAD_FAILED="❌ Download failed!"
MSG_DOWNLOAD_COMPLETE="✅ Download complete"
MSG_MOUNTING="💿 Mounting DMG..."
MSG_MOUNT_FAILED="❌ Failed to mount DMG"
MSG_MOUNTED="✅ DMG mounted"
MSG_CLOSING_APP="🔄 Closing current application..."
MSG_REMOVING_OLD="🗑️  Removing old version..."
MSG_COPYING_NEW="📁 Copying new version..."
MSG_APP_NOT_FOUND="❌ Application not found in DMG"
MSG_COPIED="✅ Application copied"
MSG_REMOVING_QUARANTINE="🔓 Removing quarantine (xattr -cr)..."
MSG_QUARANTINE_REMOVED="✅ Quarantine removed"
MSG_UNMOUNTING="💿 Unmounting DMG..."
MSG_UPDATE_SUCCESS="✅ UPDATE COMPLETED SUCCESSFULLY!"
MSG_OLD_VERSION="Old version"
MSG_NEW_VERSION_LABEL="New version"
MSG_API_ERROR="❌ Cannot access GitHub API"
MSG_SELECT_LANGUAGE="Select language"
MSG_OPENING_APP="🚀 Opening application..."
```

## Questions?

Open an issue or contact [@ercanatay](https://github.com/ercanatay).
