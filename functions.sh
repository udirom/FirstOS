#!/usr/bin/env bash

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
PINK='\033[1;35m'
YELLOW='\033[0;33m'

##
# More consistent echo.
#
ec() {
  IFS=' ' printf "%b\n" "$*"
}

##
# Outputs new line.
# No parameters.
#
br() {
  ec ''
}

success() {
  ec "${GREEN}$1${NC}"
}

info() {
  ec "${PINK}$1${NC}"
}

warn() {
  ec "${YELLOW}$1${NC}"
}

error() {
  >&2 ec "${RED}ERROR: $1${NC}"
}

fail() {
  error "$@"
  exit 1
}


function get-github-latest-release-path {
    echo $(wget -q https://github.com/$1/$2/releases -O - | egrep "$3" | head -n 1 | cut -d '"' -f 2)
}

function install-github-release-deb {
    local release_path=$(get-github-latest-release-path $1 $2 $3)
    local release_file=${release_path##*/}
    local temp_deb_folder=$(mktemp -d)
    local the_deb="$temp_deb_folder/pkg.deb"

    echo "Downloading https://github.com/$release_path"
    wget -O $the_deb "https://github.com/$release_path" &>/dev/null
    echo "Installing $release_file"
    sudo apt install $the_deb -y -qq &>/dev/null
    sudo rm -Rf $temp_deb_folder
}

function install-github-release-deb-if-missing {
# $1 - test commnad to check if missing
# $2 - github user
# $3 - github repo
# $4 - release file regex
if ! command -v $1 &> /dev/null
then
	install-github-release-deb $2 $3 $4
else
    echo "$1 already installed"
fi
}