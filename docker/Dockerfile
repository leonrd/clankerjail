ARG UBUNTU_VERSION=24.04

FROM ubuntu:$UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=UTC

# Switch to root user for system config and package install
USER root

# Install locale-gen and add en_US.UTF-8
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install basic tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    man-db less sed curl wget git vim nano make bash tmux unzip gnupg gnupg2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install awesome tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh fzf jq ripgrep bat git-flow htop dfc sqlite3 imagemagick ffmpeg sox \
    rename rlwrap screen tree watchman \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install rbenv
RUN apt-get update && apt-get install -y --no-install-recommends \
    rbenv  \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -fsSL https://astral.sh/uv/install.sh | sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Install system nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Install extra tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install git-delta
ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) \
    && wget -q -O /tmp/git-delta.deb \
        "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" \
    && dpkg -i /tmp/git-delta.deb \
    && rm /tmp/git-delta.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG CLANKER_UID=1000
ARG CLANKER_GID=1000

# Change default ubuntu user's UID so it doesn't collide with the requested UID for the clanker user
RUN UBUNTU_UID=$(id -u ubuntu) && \
    if [ "${CLANKER_UID}" = "${UBUNTU_UID}" ]; then \
        usermod -u $((UBUNTU_UID + 1)) ubuntu; \
    fi

# Change default ubuntu user's GID so it doesn't collide with the requested GID for the clanker user
RUN UBUNTU_GID=$(id -g ubuntu) && \
    if [ "${CLANKER_GID}" = "${UBUNTU_GID}" ]; then \
        groupmod -g $((UBUNTU_GID + 1)) ubuntu && usermod -g $((UBUNTU_GID + 1)) ubuntu; \
    fi

# Add non-root, non-sudoer clanker user

ARG CLANKER_USER=clanker

RUN groupadd --gid $CLANKER_GID $CLANKER_USER \
    && useradd --uid $CLANKER_UID --gid $CLANKER_GID --shell /usr/bin/zsh --create-home $CLANKER_USER

# Switch to non-root, non-sudoer clanker user
USER $CLANKER_USER

COPY --chown=$CLANKER_USER dotfiles/ /home/$CLANKER_USER/

# Install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && mv $HOME/.zshrc $HOME/.zshrc.post-oh-my-zsh \
    && mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc

# Install zsh plugins
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab

# Set global node prefix to $HOME subdir
RUN [ -f "$HOME/.profile" ] && . $HOME/.profile \
    && mkdir -p $NPM_PREFIX \
    && npm config set prefix "$NPM_PREFIX"

# Install n
RUN [ -f "$HOME/.profile" ] && . $HOME/.profile \
    && npm install -g n

# Install node through n
ARG NODE_VERSION=20.20
RUN [ -f "$HOME/.profile" ] && . $HOME/.profile \
    && n $NODE_VERSION \
    && npm install -g yarn \
    && ls -la `which node` && ls -la `which npm` && node -v && yarn --version

# Install Claude Code
RUN [ -f "$HOME/.profile" ] && . $HOME/.profile \
    && curl -fsSL https://claude.ai/install.sh | bash

# Install Codex CLI
RUN [ -f "$HOME/.profile" ] && . $HOME/.profile \
    && npm i -g @openai/codex

# Install OpenCode
RUN [ -f "$HOME/.profile" ] && . $HOME/.profile \
    && curl -fsSL https://opencode.ai/install | bash

# Switch to workspace
WORKDIR /workspace

CMD ["/usr/bin/zsh"]
