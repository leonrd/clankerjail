#!/usr/bin/env bash

set -x

# Ask for the administrator password upfront
sudo -v

# Keep-alive sudo until script has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

sudo apt-get update -y

sudo apt-get install -y --no-install-recommends \
	man-db less sed curl wget git vim nano make bash tmux unzip gnupg gnupg2

sudo apt-get install -y --no-install-recommends \
	ssh \
	&& sudo systemctl start ssh \
	&& sudo systemctl enable ssh

sudo apt-get install -y --no-install-recommends \
	zsh fzf jq ripgrep bat git-flow htop dfc sqlite3 imagemagick ffmpeg sox \
	screen rename rlwrap tree watchman

GIT_DELTA_VERSION=0.18.2 
ARCH=$(dpkg --print-architecture)
wget -q -O /tmp/git-delta.deb \
	"https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" \
&& sudo dpkg -i /tmp/git-delta.deb \
&& rm /tmp/git-delta.deb

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv $HOME/.zshrc $HOME/.zshrc.post-oh-my-zsh
mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab

# Make zsh the default shell
chsh -s $(which zsh)

sudo apt-get install -y --no-install-recommends rbenv
rbenv install

# curl https://pyenv.run | bash
# pyenv install

curl -fsSL https://astral.sh/uv/install.sh | sh
uv self update

sudo apt-get install -y --no-install-recommends nodejs
NPM_PREFIX=${NPM_PREFIX:-"$HOME/.npm-global"} \
N_PREFIX=${NPM_PREFIX:-"$HOME/.n"} \
	mkdir -p $NPM_PREFIX \
	&& npm config set prefix "$NPM_PREFIX" \
	&& npm install -g n \
	&& n lts \
	&& npm install -g yarn

sudo apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl software-properties-common \
	&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
	&& sudo apt-get update \
	&& apt-cache policy docker-ce \
	&& sudo apt-get install -y --no-install-recommends docker-ce \
	&& sudo usermod -aG docker ${USER}
sudo apt-get install -y --no-install-recommends docker-compose-plugin

# Install Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Create a symbolic link to add kitty to PATH (assuming $HOME/.local/bin is in
# your system-wide PATH)
ln -s $HOME/.local/kitty.app/bin/kitty $HOME/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp $HOME/.local/kitty.app/share/applications/kitty.desktop $HOME/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp $HOME/.local/kitty.app/share/applications/kitty-open.desktop $HOME/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty.desktop file(s)
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" $HOME/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" $HOME/.local/share/applications/kitty*.desktop

# Make kitty the default terminal emulator
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator `which kitty` 50

wget -O - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/openresty.list
sudo apt-get update && sudo apt-get install -y --no-install-recommends openresty

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg \
	&& echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list \
	&& sudo apt-get update \
	&& sudo apt-get install -y --no-install-recommends sublime-text sublime-merge

sudo apt-get install -y --no-install-recommends gthumb

curl -sLO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb && rm -f google-chrome-stable_current_amd64.deb

curl -fsSL https://tailscale.com/install.sh | sh

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt-get update && sudo apt-get install -y --no-install-recommends code

curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y --no-install-recommends spotify-client

sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt-get install -y --no-install-recommends dbeaver-ce

sudo apt-get install -y --no-install-recommends openjdk-11-jdk
sudo add-apt-repository -y ppa:maarten-fonville/android-studio
sudo apt-get update && sudo apt-get install -y --no-install-recommends android-studio

./cleanup-packages.sh
