# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# * ~/.config/shell/path can be used to extend `$PATH`.
if [ -f "$HOME/.config/shell/path" ]; then
    . "$HOME/.config/shell/path"
else
	export PATH=$HOME/bin:$HOME/.local/bin:$PATH
fi

# * ~/.config/shell/extra can be used for other settings you don’t want to commit.
for file in $HOME/.config/shell/exports $HOME/.config/shell/aliases $HOME/.config/shell/extra; do
	[ -r "$file" ] && [ -f "$file" ] && . "$file"
done
unset file
