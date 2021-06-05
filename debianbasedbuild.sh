#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DISTRO=$(lsb_release -i | awk '{print $3}')
source "$SCRIPT_DIR/debug.sh"

source $SCRIPT_DIR/functions.sh

echo "Updating system"
sudo apt update -qq &>/dev/null
sudo apt upgrade -y -qq &>/dev/null


# Instal Nvidia drivers for Debian
if [ "$DISTRO" == "Debian" ]
then
	echo "This is Debian, installing Nvidia drivers if necessary"
	sh -c "$SCRIPT_DIR/nvidia.sh"

	echo "Installing codecs"
	sudo apt install libavcodec-extra vlc -y -qq &>/dev/null
fi

# Instal Nvidia drivers for Pop
if [ "$DISTRO" == "Pop" ]
then
    read -p "Do you want to install Nvidia drivers? (y/N) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo apt install -y -qq nvidia-driver-460
    fi
fi


echo "Installing base packages"
sudo apt install -y -qq \
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
		autojump &>/dev/null

if command -v gnome-shell &> /dev/null
then
  echo "Install Gnome tweaks and extensions"
	sudo apt install gnome-shell-extensions gnome-tweaks -y -qq &>/dev/null
fi


#Install from 3rd party repos
if ! command -v brave-browser &> /dev/null
then
    echo "Installing Brave browser"
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg &>/dev/null
	sudo echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update -qq &>/dev/null
	sudo apt install brave-browser -y --no-install-recommends -qq &>/dev/null
fi

## Timeshift
if ! command -v timeshift &> /dev/null
then
	echo "Installing timeshift"
	if [ "$DISTRO" == "Debian" ]
	then
		sudo apt install timeshift -y -qq &>/dev/null
	else
	  sudo add-apt-repository -y ppa:teejee2008/ppa
		sudo apt update -qq &>/dev/null
		sudo apt install timeshift -y -qq &>/dev/null
	fi
fi

## Flatpak
if ! command -v flatpak &> /dev/null
then
    echo "Installing flatpak"
	sudo apt install flatpak -y -qq
	dpkg -l | grep -qw gnome-software || sudo apt install gnome-software-plugin-flatpak &>/dev/null
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null


#Manual installs
echo "Installing AppImageLauncher"
install-github-release-deb-if-missing appimagelauncherd TheAssassin AppImageLauncher "appimagelauncher.+amd64.deb"


echo "Installing LSD (colored ls)"
install-github-release-deb-if-missing lsd Peltoche lsd "lsd_.*_amd64.deb"

if ! command -v rsfetch &> /dev/null
then
	echo "Installing rsfetch (fast neofetch)"
	wget https://github.com$(wget -q https://github.com/rsfetch/rsfetch/releases -O - | egrep "download/.+rsfetch" | head -n 1 | cut -d '"' -f 2) &>/dev/null
	sudo chmod +x rsfetch
	sudo mv rsfetch /usr/local/bin
fi

echo "Installing Mailspring email client"
install-github-release-deb-if-missing mailspring Foundry376 Mailspring "mailspring.+amd64.deb"

echo "Installing Spotify"
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
sudo echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y -qq spotify-client

echo "Install Zoom"
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install -y -qq ./zoom_amd64.deb
rm zoom_amd64.deb

echo "Install Slack"
if ! command -v slack &> /dev/null
then
	if [ "$DISTRO" == "Pop" ]
	then
		sudo apt install slack-desktop
	else
		curl -s https://packagecloud.io/install/repositories/slacktechnologies/slack/script.deb.sh | sudo bash
	fi 
fi

echo "Install Simplenote"
install-github-release-deb-if-missing simplenote Automattic simplenote-electron "Simplenote-linux.*amd64.deb"

echo "Install Telegram"
if [ "$DISTRO" == "Pop" ]
then
	sudo apt install -y -qq telegram-desktop
else
	sudo add-apt-repository -y ppa:atareao/telegram
	sudo apt update && sudo apt install -y -qq telegram
fi

echo "Install transmission"
if [ "$DISTRO" == "Pop" ]
then
	sudo apt install -y -qq transmission
else
	sudo add-apt-repository -y ppa:transmissionbt/ppa
	sudo apt update && sudo apt install -y -qq transmission
fi

echo "Install vscode"
if [ "$DISTRO" == "Pop" ]
then
	sudo apt install -y -qq code
else
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt update
	sudo apt install code
fi

echo "Install Jetbrains Toolbox"
bash -c "$SCRIPT_DIR/jetbrains-toolbox.sh"
# Handle change sync slowness
sudo sh -c "echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf"

echo "Install walc Appimage to Applications"
wget -c https://github.com/$(wget -q https://github.com/cstayyab/WALC/releases -O - | grep "walc.AppImage" | head -n 1 | cut -d '"' -f 2) -P ~/Applications/
chmod +x ~/Applications/walc.AppImage

if ! command -v docker &> /dev/null
then
	echo "Installing docker"
	if [ "$DISTRO" == "Debian" ]
	then
		 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
		 echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		 sudo apt-get update -qq
		 sudo apt-get install docker-ce docker-ce-cli containerd.io -qq
	else
		sudo sh -c "$(curl -fsSL https://get.docker.com)"
		sudo apt-get install -y -qq uidmap &>/dev/null
	fi

	#dockerd-rootless-setuptool.sh install
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi

echo "Installing Fonts"
sudo add-apt-repository multiverse &>/dev/null
sudo apt update -qq &>/dev/null && sudo apt install ttf-mscorefonts-installer -y -qq

curl -sS https://webinstall.dev/nerdfont | bash &>/dev/null

git clone https://github.com/powerline/fonts
cd fonts
./install.sh &>/dev/null
cd ..
rm -Rf fonts

sudo fc-cache -f -v
sudo apt autoremove -qq &>/dev/null

if ! command -v starship &> /dev/null
then
	echo "Installing starship prompt"
	sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
fi

zsh -c "$SCRIPT_DIR/user_setup.sh"
