#!/usr/bin/env bash

# Install the Solarized Dark theme for iTerm
mkdir -p "${HOME}/Library/Application Support/iTerm2"
ln -s "${HOME}/.config/macos/Library/Application Support/iTerm2/Solarized Dark.itermcolors" "${HOME}/Library/Application Support/iTerm2/Solarized Dark.itermcolors"
open "${HOME}/Library/Application Support/iTerm2/Solarized Dark.itermcolors"

# Import iTerm profile
mkdir -p "${HOME}/Library/Application Support/iTerm2/DynamicProfiles"
ln -s "${HOME}/.config/macos/Library/Application Support/iTerm2/DynamicProfiles/Profiles.json" "${HOME}/Library/Application Support/iTerm2/DynamicProfiles"

# Install Sublime Text settings
mkdir -p "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/"
ln -s "${HOME}/.config/sublime-text/Packages/User/Preferences.sublime-settings" "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"

# Install Sublime Merge settings
mkdir -p "${HOME}/Library/Application Support/Sublime Merge/Packages/User/"
ln -s "${HOME}/.config/sublime-merge/Packages/User/Preferences.sublime-settings" "${HOME}/Library/Application Support/Sublime Merge/Packages/User/Preferences.sublime-settings"
ln -s "${HOME}/.config/sublime-merge/Packages/User/Diff.sublime-settings" "${HOME}/Library/Application Support/Sublime Merge/Packages/User/Diff.sublime-settings"

# Install VSCode settings
mkdir -p "${HOME}/Library/Application Support/Code/User/"
ln -s "${HOME}/.config/Code/User/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"

# Set up my preferred keyboard shortcuts
mkdir -p "${HOME}/Library/Application Support/Spectacle"
ln -s "${HOME}/.config/macos/Library/Application Support/Spectacle/Shortcuts.json" "${HOME}/Library/Application Support/Spectacle/Shortcuts.json"

# Install the BTT preset
mkdir -p "${HOME}/Library/Application Support/BetterTouchTool/"
ln -s "${HOME}/.config/macos/Library/Application Support/BetterTouchTool/Default.bttpreset" "${HOME}/Library/Application Support/BetterTouchTool/Default.bttpreset"
open "${HOME}/Library/Application Support/BetterTouchTool/Default.bttpreset"
