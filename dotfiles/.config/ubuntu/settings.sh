# Turn off apt news
sudo pro config set apt_news=false

# Fix audio
sudo touch /usr/share/pipewire/media-session.d/with-pulseaudio
systemctl --user restart pipewire-session-manager

# Disable system sounds
gsettings set org.gnome.desktop.sound event-sounds false

# Prefer dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Window buttons to the left
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Disable auto maximize since it causes some apps to always open maximized
gsettings set org.gnome.mutter auto-maximize false

# Center new windows (for applications that don't save window position/size)
gsettings set org.gnome.mutter center-new-windows true

# Strict mode window focus
gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'smart'

# Disable caps lock (make sure you have it off when setting this)
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:none']"

# Disable monitor reset key
gsettings set org.gnome.mutter.keybindings switch-monitor "[]"

# Disable super+# hot keys
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
gsettings set org.gnome.shell.extensions.dash-to-dock hotkeys-overlay false
gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"

gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"

# macos-like screenshots
gsettings set org.gnome.shell.keybindings screenshot "['<Shift><Super>3', '<Shift>Print']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>4', 'Print']"

# macos-like keyboard overview/app views
gsettings set org.gnome.mutter overlay-key ""
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>Up', 'LaunchA', '<Super>s']"
gsettings set org.gnome.shell.keybindings toggle-application-view "['LaunchB','<Super>a']"
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>Space']"

# window mgmt keys
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']"
gsettings set org.gnome.desktop.wm.keybindings begin-move "[]"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "[]"

gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Primary><Alt><Super>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Primary><Alt><Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Primary><Alt><Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Primary><Alt><Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "[]"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h']"
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Primary><Alt>d']"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Control><Alt>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Page_Up', '<Super><Alt>Left', '<Control><Alt>Left']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Control><Alt>Down']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Page_Down', '<Super><Alt>Right', '<Control><Alt>Right']"

gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>Above_Tab', '<Alt>Above_Tab']"

gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'none'

# Remove cmd+n mapping
gsettings set org.gnome.shell.keybindings focus-active-notification "[]"

# Remove cmd+v mapping
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>m']"

# Dock
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.0
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'kitty.desktop', 'spotify_spotify.desktop', 'code_code.desktop', 'sublime_text.desktop', 'sublime_merge.desktop', 'slack_slack.desktop', 'vlc_vlc.desktop']"
gsettings set org.gnome.shell.extensions.dash-to-dock application-counter-overrides-notifications true
gsettings set org.gnome.shell.extensions.dash-to-dock show-icons-notifications-counter false

# Files
gsettings set org.gnome.nautilus.preferences always-use-location-entry true
gsettings set org.gnome.nautilus.preferences show-hidden-files true
gsettings set org.gtk.Settings.FileChooser show-hidden true

# Set kitty as default terminal app
gsettings set org.gnome.desktop.default-applications.terminal exec kitty
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ""
