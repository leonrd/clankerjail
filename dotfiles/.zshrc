# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# * ~/.path can be used to extend `$PATH`.
if [ -f "$HOME/.config/shell/path" ]; then
  source "$HOME/.config/shell/path"
else
	export PATH=$HOME/bin:$HOME/.local/bin:$PATH
fi

# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.config/shell/{exports,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Path to your Oh My Zsh installation.
if [ -x $HOME/.oh-my-zsh ]; then
	export ZSH="$HOME/.oh-my-zsh"
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fzf-tab zsh-autosuggestions zsh-navigation-tools git-flow sublime postgres)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
if [ $(uname -s) = 'Darwin' ]; then
	plugins+=(macos brew )
fi

if [ -x $HOME/.oh-my-zsh ]; then
	source $ZSH/oh-my-zsh.sh
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# zsh-autosuggest
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bold,underline"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="vim ~/.zshrc"
# alias ohmyzsh="vim ~/.oh-my-zsh"

if [ -f "$HOME/.config/shell/aliases" ]; then
  source "$HOME/.config/shell/aliases"
fi

# Input

# Use the text that has already been typed as the prefix for searching through
# commands (i.e. more intelligent Up/Down behavior)
bindkey "\e[B" history-search-forward
bindkey "\e[A" history-search-backward

# Use Alt/Meta + arrows to navigate between words
# iTerm
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word
# kitty
bindkey "\e[1;3D" backward-word
bindkey "\e[1;3C" forward-word

# Use Alt/Meta + Delete to delete the preceding word
bindkey "\e[3;3~" kill-word

# Fzf completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Other

if [ $(uname -s) = 'Darwin' ]; then
	test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

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
	eval "$(pyenv init - zsh)"
fi

if command -v uv 1>/dev/null 2>&1; then
 eval "$(uv generate-shell-completion zsh)"
fi

if command -v uvx 1>/dev/null 2>&1; then
 eval "$(uvx --generate-shell-completion zsh)"
fi
