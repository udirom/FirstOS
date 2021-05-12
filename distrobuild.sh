#!/bin/sh

# Start by updating everything
sudo apt update && sudo apt upgrade -y


#Install from apt repos
sudo apt install -y --no-install-recommends gparted fd-find build-essential ca-certificates gnupg lsb-release software-properties-common make git curl wget easy-rsa software-properties-common apt-transport-https python3-pip python3-venv python3-testresources python3-dev libssl-dev libffi-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev tig fd-find jq network-manager-openvpn zsh fish fzf tmux vim autojump

#Install from 3rd party repos
##Install Brave

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser -y

## Timeshift
sudo add-apt-repository -y ppa:teejee2008/ppa
sudo apt update
sudo apt install timeshift

#Manual installs
## Install AppImageLauncher
wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb

sudo apt install ./appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb -y

rm appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb


## exa
wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip
unzip exa-linux-x86_64-v0.10.1.zip -d exa
cp exa/bin/exa /usr/local/bin/
rm -rf exa

## Install Mailspring
wget https://github.com/Foundry376/Mailspring/releases/download/1.9.1/mailspring-1.9.1-amd64.deb
sudo apt install ./mailspring-1.9.1-amd64.deb -y
rm mailspring-1.9.1-amd64.deb

#Install docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

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
sudo apt autoremove

#Install starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
