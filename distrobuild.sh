# Start by updating everything
sudo apt update && sudo apt upgrade -y


#Ubuntu adjustments
## Install flatpak
sudo apt install flatpak -y
sudo apt install gnome-software-plugin-flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Install timeshift
sudo add-apt-repository -y ppa:teejee2008/ppa
sudo apt update
sudo apt install timeshift

## To enable touch tap in KDE
sudo apt install xserver-xorg-input-evdev

#Install from apt repos
sudo apt install -y build-essential \
       	vim \
	tmux \
       	git \
       	curl \
       	wget \
       	software-properties-common \
       	apt-transport-https \
	python3-pip \
	python3-dev \
	libssl-dev \
	libffi-dev \
	python3-venv \
	python3-testresources \
	fzf \
	tig \
	fd-find




##Install Fonts
sudo add-apt-repository multiverse
sudo apt update && sudo apt install ttf-mscorefonts-installer -y
curl -sS https://webinstall.dev/nerdfont | bash
sudo fc-cache -f -v


#Install from 3rd party repos
##Install Brave
sudo apt install apt-transport-https curl

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
## Install Jetbrains tools
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate -y
flatpak install flathub com.jetbrains.DataGrip -y
## Install Desktop utilities
flatpak install -y flathub com.spotify.Client -y
flatpak install flathub io.bit3.WhatsAppQT -y
flatpak install flathub org.fedoraproject.MediaWriter -y
flatpak install flathub us.zoom.Zoom -y
flatpak install flathub com.slack.Slack -y
flatpak run com.simplenote.Simplenote -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.transmissionbt.Transmission -y
flatpak install flathub org.pulseaudio.pavucontrol -y
flatpak install flathub org.gnome.Boxes -y

#Dev
## Python
###Pyenv
sudo apt install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init --path)"' >> ~/.profile

source ~/.profile

### Pips
pip3 install ipython pipenv poetry


## Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install --lts
nvm use --lts
npm install -g yarn typescript lerna create-react-app

## Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
