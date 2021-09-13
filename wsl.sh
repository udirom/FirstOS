#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DISTRO=$(lsb_release -i | awk '{print $3}')
source "$SCRIPT_DIR/debug.sh"

source $SCRIPT_DIR/functions.sh

echo "Updating system"
sudo apt update -qq &>/dev/null
sudo apt upgrade -y -qq &>/dev/null


echo "Installing base packages"
sudo apt install -y -qq \
        micro \
		flameshot \
		ccze \
		catfish \
  		rar \
   		unrar \
		gparted \
		fd-find \
		build-essential \
		ca-certificates \
		gnupg \
		lsb-release \
		make \
		git \
		curl \
		wget \
		easy-rsa \
		software-properties-common \
		apt-transport-https \
		python3-pip \
		python3-venv \
		python3-testresources \
		python3-dev \
		libssl-dev \
		libffi-dev \
		zlib1g-dev \
		libbz2-dev \
		libreadline-dev \
		libsqlite3-dev \
		llvm \
		libncurses5-dev \
		xz-utils \
		tk-dev \
		libxml2-dev \
		libxmlsec1-dev \
		libffi-dev \
		liblzma-dev \
		tig \
		fd-find \
		jq \
		network-manager-openvpn \
		zsh \
		fish \
		fzf \
		tmux \
		vim \
		wireguard \
		openresolv \
		lsof \
		multitail \
		bat \
		ranger \
		xdg-utils \
		autojump &>/dev/null



echo "Installing LSD (colored ls)"
install-github-release-deb-if-missing lsd Peltoche lsd "lsd_.*_amd64.deb"

if ! command -v rsfetch &> /dev/null
then
	echo "Installing rsfetch (fast neofetch)"
	wget https://github.com$(wget -q https://github.com/rsfetch/rsfetch/releases -O - | egrep "download/.+rsfetch" | head -n 1 | cut -d '"' -f 2) &>/dev/null
	sudo chmod +x rsfetch
	sudo mv rsfetch /usr/local/bin
fi


#echo "Install Jetbrains Toolbox"
#bash -c "$SCRIPT_DIR/jetbrains-toolbox.sh"
# Handle change sync slowness
#sudo sh -c "echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf"

if ! command -v starship &> /dev/null
then
	echo "Installing starship prompt"
	sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
fi

zsh -c "$SCRIPT_DIR/user_setup.sh"
