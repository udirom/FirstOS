#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DISTRO=$(lsb_release -i | awk '{print $3}')
source "$SCRIPT_DIR/debug.sh"

source $SCRIPT_DIR/functions.sh

echo "Update debian apt sources"
sudo rm /etc/apt/sources.list
sudo cp $SCRIPT_DIR/debian/sources.list /etc/apt/

echo "Updating system"
sudo apt update -qq
sudo apt upgrade -y -qq


# Install Nvidia drivers for Debian
if [ "$DISTRO" == "Debian" ]
then
	echo "This is Debian, installing Nvidia drivers if necessary"
	sh -c "$SCRIPT_DIR/nvidia.sh"

	echo "Installing codecs"
	sudo apt install libavcodec-extra vlc -y -qq

	# Fixing bluetooth audio
	sudo apt install -y -qq pulseaudio-module-bluetooth
fi

# Fix touchpad on Pop
sudo sh -c "echo 'options psmouse synaptics_intertouch=0' > /etc/modprobe.d/trackpad.conf"

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
		cmake \
		autojump \
		chromium

if command -v gnome-shell &> /dev/null
then
  echo "Install Gnome tweaks and extensions"
	sudo apt install gnome-shell-extensions gnome-tweaks -y -qq
fi


#Install from 3rd party repos

## Timeshift
if ! command -v timeshift &> /dev/null
then
	echo "Installing timeshift"
	if [ "$DISTRO" == "Debian" ]
	then
		sudo apt install timeshift -y -qq
	else
	  sudo add-apt-repository -y ppa:teejee2008/ppa
		sudo apt update -qq &>/dev/null
		sudo apt install timeshift -y -qq
	fi
fi

if [ "$DISTRO" == "Debian" ]
then
	if command -v plasmashell &> /dev/null
	then
		sudo apt install -y -qq sddm-theme-debian-breeze
	fi

	sudo apt install -y -qq printer-driver-all system-config-printer
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
sudo apt install -y -qq gnome-keyring
install-github-release-deb-if-missing mailspring Foundry376 Mailspring "mailspring.+amd64.deb"

echo "Installing Spotify"
if ! command -v spotify &> /dev/null
then
	curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
	sudo echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get install -y -qq spotify-client
fi

echo "Install Zoom"
if ! command -v slack &> /dev/null
then
	wget https://zoom.us/client/latest/zoom_amd64.deb
	sudo apt install -y -qq ./zoom_amd64.deb
	rm zoom_amd64.deb
fi

echo "Install Slack"
if ! command -v slack &> /dev/null
then
	if [ "$DISTRO" == "Pop" ]
	then
		sudo apt install slack-desktop
	else
		wget http://http.us.debian.org/debian/pool/main/libi/libindicator/libindicator3-7_0.5.0-4_amd64.deb
		wget http://http.us.debian.org/debian/pool/main/liba/libappindicator/libappindicator3-1_0.4.92-8_amd64.deb
		sudo apt install -y ./libindicator3-7_0.5.0-4_amd64.deb
		sudo apt install -y ./libappindicator3-1_0.4.92-8_amd64.deb
		rm libindicator3-7_0.5.0-4_amd64.deb
		rm libappindicator3-1_0.4.92-8_amd64.deb

		latest_slack=$(curl -fsSl https://slack.com/intl/en-il/downloads/instructions/ubuntu | grep -Eo "https://downloads.slack-edge.com/releases/linux/.+deb")
		wget $latest_slack
		sudo apt install -y -qq ./slack-desktop*.deb
		rm slack-desktop*
	fi 
fi

echo "Install Simplenote"
install-github-release-deb-if-missing /opt/Simplenote/simplenote Automattic simplenote-electron "Simplenote-linux.*amd64.deb"

echo "Install Telegram"
sudo apt install -y -qq telegram-desktop

echo "Install transmission"
sudo apt install -y -qq transmission

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

echo "Install Whatsapp for linux"
install-github-release-deb-if-missing whatsapp-for-linux eneshecan whatsapp-for-linux "whatsapp-for-linux.+amd64.deb"

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

echo "Install dive docker image analyzer"
install-github-release-deb-if-missing dive wagoodman dive "dive.+linux_amd64.deb"

echo "Installing Fonts"
sudo apt update -qq && sudo apt install ttf-mscorefonts-installer -y -qq

curl -sS https://webinstall.dev/nerdfont | bash &>/dev/null

git clone https://github.com/powerline/fonts
cd fonts
./install.sh &>/dev/null
cd ..
rm -Rf fonts

# Install MesloLGS
mkdir -p $HOME/.fonts
curl -sLo $HOME/.fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -sLo $HOME/.fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -sLo $HOME/.fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -sLo $HOME/.fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

sudo fc-cache -f -v

echo "Cleanup"
if [ "$DISTRO" == "Debian" ]
then
	sudo apt-get purge -y hdate-applet goldendict kasumi evolution cheese rhythmbox shotwell mozc-utils-gui mlterm uim im-config xterm gnome-2048 aisleriot atomix gnome-chess five-or-more hitori iagno gnome-klotski lightsoff gnome-mahjongg gnome-mines gnome-nibbles quadrapassel four-in-a-row gnome-robots gnome-sudoku swell-foop tali gnome-taquin gnome-tetravex
	sudo apt-get purge -y fcitx*
	sudo apt-get purge -y xiterm+thai
fi

sudo apt autoremove -y -qq

if ! command -v starship &> /dev/null
then
	echo "Installing starship prompt"
	sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
fi

zsh -c "$SCRIPT_DIR/user_setup.sh"
