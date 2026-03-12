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

RUN groupadd --gid "${CLANKER_GID}" "${CLANKER_USER}" \
    && useradd --uid "${CLANKER_UID}" --gid "${CLANKER_GID}" --shell /usr/bin/zsh --create-home "${CLANKER_USER}"

# Switch to non-root, non-sudoer clanker user
USER "${CLANKER_USER}"

# Switch to workspace
WORKDIR /workspace

CMD ["zsh", "-l"]
