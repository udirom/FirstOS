#!/bin/sh

# Start by updating everything
sudo apt update && sudo apt upgrade -y


#Install from apt repos
sudo apt install -y --no-install-recommends \
    build-essential \
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
flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Ultimate \
	flatpak install flathub com.jetbrains.DataGrip \
	flatpak install -y flathub com.spotify.Client \
	flatpak install flathub io.bit3.WhatsAppQT \
	flatpak install flathub org.fedoraproject.MediaWriter \
	flatpak install flathub us.zoom.Zoom \
	flatpak install flathub com.slack.Slack \
	flatpak run com.simplenote.Simplenote \
	flatpak install flathub com.visualstudio.code \
	flatpak install flathub com.transmissionbt.Transmission \
	flatpak install flathub org.pulseaudio.pavucontrol \
	flatpak install flathub org.gnome.Boxes


#Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"
cd ..
cp -R .asdf /etc/skel

echo '. $HOME/.asdf/asdf.sh' | tee -a ~/.bashrc /etc/skel/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' | tee -a ~/.bashrc /etc/skel/.bashrc


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
