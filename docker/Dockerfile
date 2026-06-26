ARG UBUNTU_VERSION=24.04

FROM ubuntu:$UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive

ENV TZ=UTC

# Switch to root user for system config and package install
USER root

# Upgrade existing packages
RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install locale-gen and add en_US.UTF-8
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install basic tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    man-db less sed curl wget git vim nano make bash tmux dtach unzip gnupg gnupg2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install awesome tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh fzf jq ripgrep bat git-flow htop dfc sqlite3 imagemagick ffmpeg sox \
    rename rlwrap screen tree watchman \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install some dependencies
# ca-certificates: necessary for git-delta and others
# build-essential, libz-dev, libyaml-dev: necessary for building ruby using rbenv
RUN apt-get update &&  apt-get install -y --no-install-recommends \
    ca-certificates \
	build-essential libz-dev libyaml-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extra tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    gh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install git-delta
ARG GIT_DELTA_VERSION=0.19.2
RUN ARCH=$(dpkg --print-architecture) \
    && wget -q -O /tmp/git-delta.deb \
        "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" \
    && dpkg -i /tmp/git-delta.deb \
    && rm /tmp/git-delta.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /etc/apt/trusted.gpg.d/google-chrome.gpg \
	&& ARCH=$(dpkg --print-architecture) echo "deb [arch=${ARCH} signed-by=/etc/apt/trusted.gpg.d/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends google-chrome-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG AGENT_UID=1000
ARG AGENT_GID=1000

# rename ubuntu user to agent
RUN usermod -l agent ubuntu
RUN groupmod --new-name agent ubuntu
# change agent UID/GID
RUN groupmod -g "${AGENT_GID}" agent
RUN usermod -u "${AGENT_UID}" agent
RUN usermod -g "${AGENT_GID}" agent
# change home path
RUN usermod -d /home/agent -m agent
# update the comment field of the user
RUN usermod -c "agent" agent

USER agent

# Switch to workspace
WORKDIR /workspace

CMD ["zsh", "-l"]
