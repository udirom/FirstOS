#!/bin/sh

# Start by updating everything
sudo apt update && sudo apt upgrade -y


#Install from apt repos
sudo apt install -y --no-install-recommends \
    build-essential \
	ca-certificates \
	gnupg \
	lsb-release \
	software-properties-common \
	make \
    git \
    curl \
    wget \
	easy-rsa \
    software-properties-common \
    apt-transport-https \
	# Python
	python3-pip \
	python3-venv \
	python3-testresources \
	# Deps to build python with pyenv
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
	# Shell utils
	tig \
	fd-find \
	jq \
	network-manager-openvpn

#Install from 3rd party repos
##Install Brave

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser -y

#Manual installs
## Install AppImageLauncher
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb

sudo apt install ./appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb -y

rm appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb


## Install Mailspring
wget https://github.com/Foundry376/Mailspring/releases/download/1.9.1/mailspring-1.9.1-amd64.deb
sudo apt install ./mailspring-1.9.1-amd64.deb -y
rm mailspring-1.9.1-amd64.deb


#Install Flatpaks
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt update 

sudo flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Ultimate \
	com.jetbrains.DataGrip \
	com.spotify.Client \
	io.bit3.WhatsAppQT \
	org.fedoraproject.MediaWriter \
	us.zoom.Zoom \
	com.slack.Slack \
	com.simplenote.Simplenote \
	com.visualstudio.code \
	com.transmissionbt.Transmission \
	org.pulseaudio.pavucontrol \
	org.gnome.Boxes


sudo flatpak uninstall --unused

#Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
cd ..
cp -R .asdf /etc/skel

echo '. $HOME/.asdf/asdf.sh' | tee -a ~/.bashrc /etc/skel/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' | tee -a ~/.bashrc /etc/skel/.bashrc


#Install docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo groupadd docker

##Install Fonts
sudo add-apt-repository multiverse
sudo apt update && sudo apt install ttf-mscorefonts-installer -y
curl -sS https://webinstall.dev/nerdfont | bash
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..
rm -Rf fonts
sudo fc-cache -f -v

