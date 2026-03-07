#!/usr/bin/env bash

set -E
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
	trap - SIGINT SIGTERM ERR EXIT
}

# Default arguments
update=false

usage() {
	cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-u]

A Ubuntu Cleaning up Utility based on
https://github.com/fwartner/mac-cleanup

Available options:

-h, --help       Print this help and exit
-v, --verbose    Print script debug info
-u, --update     Run apt update
EOF
	exit
}

# shellcheck disable=SC2034  # Unused variables left for readability
setup_colors() {
	if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
		NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
	else
		NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
	fi
}

msg() {
	echo >&2 -e "${1-}"
}

die() {
	local msg=$1
	local code=${2-1} # default exit status 1
	msg "$msg"
	exit "$code"
}

parse_params() {
	# default values of variables set from params
	update=false

	while :; do
		case "${1-}" in
		-h | --help) usage ;;
		-v | --verbose) set -x ;;
		--no-color) NO_COLOR=1 ;;
		-u | --update) update=true ;; # update flag
		-n) true ;;                   # This is a legacy option, now default behaviour
		-?*) die "Unknown option: $1" ;;
		*) break ;;
		esac
		shift
	done

	return 0
}

parse_params "$@"
setup_colors

bytesToHuman() {
	b=${1:-0}
	d=''
	s=1
	S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
	while ((b > 1024)); do
		d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
		b=$((b / 1024))
		((s++))
	done
	msg "$b$d ${S[$s]} of space was cleaned up"
}

__dir="$(cd "$(dirname "$0")" && pwd)"

# Ask for the administrator password upfront
sudo -v

HOST=$(whoami)

# Keep-alive sudo until script has finished
while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2>/dev/null &

oldAvailable=$(df / | tail -1 | awk '{print $4}')

# Remove Thumbnail Cache
rm -rfv ~/.cache/thumbnails/* &>/dev/null

# Remove old snaps
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

msg 'Clearing System Log Files...'
sudo rm -rfv /var/log/*gz &>/dev/null

if [ -d ~/.cache/google-chrome/ ]; then
  msg 'Clearing Google Chrome Cache Files...'
  sudo rm -rfv ~/.cache/google-chrome/Default/Cache/* &>/dev/null
fi

# Deletes Wget logs
if [ -d ~/wget-log ]; then
	msg 'Deleting Wget log and hosts file...'
	rm -fv ~/wget-log &>/dev/null
	rm -fv ~/.wget-hsts &>/dev/null
fi

# Deletes Bash/ZSH logs
#msg 'Clearing ZSH history...'
#rm -fv ~/.bash_history &>/dev/null
#msg 'ZSH history...'
#rm -fv ~/.zhistory &>/dev/null

# Deletes Android (studio?) cache
if [ -d ~/.android ]; then
	msg 'Deleting Android cache...'
	rm -rfv ~/.android/cache &>/dev/null
fi

# # Clears Gradle caches
# if [ -d ~/.gradle ]; then
# 	msg 'Clearing Gradle caches...'
# 	rm -rfv ~/.gradle/caches &>/dev/null
# fi

if type "apt" &>/dev/null; then
	if [ "$update" = true ]; then
		bash ${__dir}/cleanup-packages.sh --update
	else
		bash ${__dir}/cleanup-packages.sh
	fi
fi

if type "gem" &>/dev/null; then
	msg 'Cleaning up any old versions of gems'
	gem cleanup &>/dev/null
fi

# if type "docker" &>/dev/null; then
# 	if ! docker ps >/dev/null 2>&1; then
# 		open --background -a Docker
# 	fi
# 	msg 'Cleaning up Docker'
# 	docker system prune -af &>/dev/null
# fi

if [[ -v PYENV_VIRTUALENV_CACHE_PATH ]]; then
	msg 'Removing Pyenv-VirtualEnv Cache...'
	rm -rfv "$PYENV_VIRTUALENV_CACHE_PATH" &>/dev/null
fi

# if type "npm" &>/dev/null; then
# 	msg 'Cleaning up npm cache...'
# 	npm cache clean --force &>/dev/null
# fi

# if type "yarn" &>/dev/null; then
# 	msg 'Cleaning up Yarn Cache...'
# 	yarn cache clean --force &>/dev/null
# fi

if type "pod" &>/dev/null; then
	msg 'Cleaning up Pod Cache...'
	pod cache clean --all &>/dev/null
fi

msg "${GREEN}Success!${NOFORMAT}"

newAvailable=$(df / | tail -1 | awk '{print $4}')
count=$((newAvailable - oldAvailable))
bytesToHuman $count

cleanup
