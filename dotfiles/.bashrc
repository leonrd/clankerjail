# * ~/.config/shell/path can be used to extend `$PATH`.
if [ -f "$HOME/.config/shell/path" ]; then
  source "$HOME/.config/shell/path"
else
	export PATH=$HOME/bin:$HOME/.local/bin:$PATH
fi

# * ~/.config/shell/extra can be used for other settings you don’t want to commit.
for file in ~/.config/shell/{exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

if [ $(uname -s) = 'Darwin' ]; then
	# Add tab completion for many Bash commands
	if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
		# Ensure existing Homebrew v1 completions continue to work
		export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
		source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
	elif [ -f /etc/bash_completion ]; then
		source /etc/bash_completion;
	fi;

	# Add tab completion for `defaults read|write NSGlobalDomain`
	# You could just use `-g` instead, but I like being explicit
	complete -W "NSGlobalDomain" defaults;

	# Add `killall` tab completion for common apps
	complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
else
	if ! shopt -oq posix; then
		if [ -f /usr/share/bash-completion/bash_completion ]; then
			. /usr/share/bash-completion/bash_completion
		elif [ -f /etc/bash_completion ]; then
			. /etc/bash_completion
		fi
	fi
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Fzf completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Other

if [ $(uname -s) = 'Darwin' ]; then
	test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

	# Homebrew OCLP patch - auto-reapply after brew update
	brew() {
	    command brew "$@"
	    local ret=$?
	    if [[ "$1" == "update" ]]; then
	        curl -sL "https://raw.githubusercontent.com/ajorpheus/homebrew-oclp-patches/master/homebrew-oclp.patch" | git -C /usr/local/Homebrew apply 2>/dev/null && echo "OCLP patches restored"
	    fi
	    return $ret
	}
fi

if command -v rbenv 1>/dev/null 2>&1; then
	eval "$(rbenv init -)"
fi

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init - bash)"
fi

if command -v uv 1>/dev/null 2>&1; then
 eval "$(uv generate-shell-completion bash)"
fi

if command -v uvx 1>/dev/null 2>&1; then
 eval "$(uvx --generate-shell-completion bash)"
fi
