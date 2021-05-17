#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DISTRO=$(lsb_release -i | awk '{print $3}')


echo "Updating system"
sudo apt update -qq &>/dev/null
sudo apt upgrade -y -qq &>/dev/null


echo "Installing base packages"
sudo apt install -y -qq --no-install-recommends rar unrar gparted fd-find build-essential ca-certificates gnupg lsb-release software-properties-common make git curl wget easy-rsa software-properties-common apt-transport-https python3-pip python3-venv python3-testresources python3-dev libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev tig fd-find jq network-manager-openvpn zsh fish fzf tmux vim autojump &>/dev/null

#Install from 3rd party repos
echo "Installing Brave browser"

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg &>/dev/null

sudo echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update -qq &>/dev/null

sudo apt install brave-browser -y --no-install-recommends -qq &>/dev/null

## Timeshift
if ! command -v timeshift &> /dev/null
then
    echo "Installing timeshift"
    sudo add-apt-repository -y ppa:teejee2008/ppa
	sudo apt update -qq &>/dev/null
	sudo apt install timeshift -y -qq &>/dev/null
fi

## Flatpak
if ! command -v flatpak &> /dev/null
then
    echo "Installing flatpak"
	sudo apt install flatpak -y -qq
	dpkg -l | grep -qw gnome-software || sudo apt install gnome-software-plugin-flatpak &>/dev/null
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


#Manual installs
echo "Installing AppImageLauncher"
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb &>/dev/null

sudo apt install ./appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb -y -qq &>/dev/null

rm appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb


echo "Installing LSD (colored ls)"
wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd-0.20.1-x86_64-unknown-linux-gnu.tar.gz &>/dev/null
tar xzf lsd-0.20.1-x86_64-unknown-linux-gnu.tar.gz
sudo mv lsd-0.20.1-x86_64-unknown-linux-gnu/lsd /usr/local/bin
rm -rf lsd-0.20.1-x86_64-unknown-linux-gnu*

echo "Installing rsfetch (fast neofetch)"
wget https://github.com/rsfetch/rsfetch/releases/download/2.0.0/rsfetch &>/dev/null
sudo chmod +x rsfetch
sudo mv rsfetch /usr/local/bin

echo "Installing Mailspring email client"
wget https://github.com/Foundry376/Mailspring/releases/download/1.9.1/mailspring-1.9.1-amd64.deb &>/dev/null
sudo apt install ./mailspring-1.9.1-amd64.deb -y -qq &>/dev/null
rm mailspring-1.9.1-amd64.deb

echo "Installing docker"
sudo sh -c "$(curl -fsSL https://get.docker.com)"

sudo apt-get install -y -qq uidmap &>/dev/null

dockerd-rootless-setuptool.sh install


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

echo "Installing starship prompt"
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)"

zsh -c "$SCRIPT_DIR/user_setup.sh"