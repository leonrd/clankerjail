# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
else
	# * ~/.config/shell/path can be used to extend `$PATH`.
	if [ -f "$HOME/.config/shell/path" ]; then
    source "$HOME/.config/shell/path"
	else
		export PATH=$HOME/bin:$HOME/.local/bin:$PATH
	fi

	# * ~/.config/shell/extra can be used for other settings you don’t want to commit.
	for file in ~/.config/shell/{exports,aliases,functions,extra}; do
		[ -r "$file" ] && [ -f "$file" ] && source "$file";
	done;
	unset file;
fi
