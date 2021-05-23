#!/bin/bash

echo "Optimizing dnf"
sudo echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
sudo echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
sudo echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf

echo "Upgrade packages"
sudo dnf upgrade --refresh -q -y
sudo dnf check
sudo dnf autoremove -y -q

echo "Upgrade device firmware"
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update

echo "Enable non free repositories"
sudo dnf install -y  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf upgrade --refresh -y -q
sudo dnf groupupdate -y core
sudo dnf install -y -q rpmfusion-free-release-tainted
sudo dnf install -y -q dnf-plugins-core

echo "Enable flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

echo "Install Nvidia drivers"
sudo dnf install -y akmod-nvidia # rhel/centos users can use kmod-nvidia instead
sudo dnf install -y xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support
sudo dnf install -y xorg-x11-drv-nvidia-cuda-libs
sudo dnf install -y vdpauinfo libva-vdpau-driver libva-utils
sudo dnf install -y vulkan

echo "Install Gnome tweaks and extensions"
sudo dnf install -y -q gnome-extensions-app gnome-tweaks gnome-shell-extension-appindicator

echo "Install fonts"
sudo dnf install -y fira-code-fonts 'mozilla-fira*' 'google-roboto*'
curl -sS https://webinstall.dev/nerdfont | bash &>/dev/null

git clone https://github.com/powerline/fonts
cd fonts
./install.sh &>/dev/null
cd ..
rm -Rf fonts

sudo fc-cache -f -v &>/dev/null

echo "Install timeshift"
sudo dnf install -y timeshift

echo "Install utilities"
sudo dnf install -y unrar gparted fd-find ca-certificates gnupg make git curl wget easy-rsa python3-testresources python3-devel openssl-devel libffi-devel zlib bzip2-libs readline-devel sqlite-libs llvm ncurses-devel xz tk-devel libxml2-devel xmlsec1 libffi-devel lzma-sdk tig fd-find jq zsh fish fzf tmux vim autojump lsd
sudo dnf install -y git git-lfs gparted
git-lfs install
sudo dnf -y install unzip p7zip p7zip-plugins 

echo "build essentials"
sudo dnf install -y gcc gcc-g++ make autoconf automake kernel-devel redhat-rpm-config

echo "Install Appimagelauncher"
sudo rpm -i https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm

if ! command -v rsfetch &> /dev/null
then
	echo "Installing rsfetch (fast neofetch)"
	wget https://github.com/rsfetch/rsfetch/releases/download/2.0.0/rsfetch &>/dev/null
	sudo chmod +x rsfetch
	sudo mv rsfetch /usr/local/bin
fi

if ! command -v mailspring &> /dev/null
then
	echo "Installing Mailspring email client"
	rpm -i https://github.com/Foundry376/Mailspring/releases/download/1.9.1/mailspring-1.9.1-0.1.x86_64.rpm &>/dev/null
	sudo apt install ./mailspring-1.9.1-amd64.deb -y -qq &>/dev/null
	rm mailspring-1.9.1-amd64.deb
fi

echo "Install mscore fonts"
sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

echo "Install multimedia codecs"
sudo dnf install -y vlc
sudo dnf groupupdate -y sound-and-video
sudo dnf install -y libdvdcss
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg 
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade -y --with-optional Multimedia


echo "Power management optimization"
dnf install -y tlp tlp-rdw
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc$(rpm -E %fedora).noarch.rpm
dnf install -y kernel-devel akmod-acpi_call akmod-tp_smapi

sudo dnf install -y brave-browser


echo "Install Docker"

sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf -y install dnf-plugins-core

sudo dnf config-manager -y \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo


sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo dnf autoremove -y


# Install nonfree apps
git clone https://github.com/rpmfusion-infra/fedy.git

echo "Install Jetbrains toolbox"
chmod +x fedy/plugins/jetbrains-toolbox.plugin/install.sh
(cd fedy/plugins/jetbrains-toolbox.plugin/ && sudo su root bash -c ./install.sh)

echo "Install Postman"
chmod +x fedy/plugins/postman.plugin/install.sh
(cd fedy/plugins/postman.plugin/ && sudo su root bash -c ./install.sh)


echo "Install Simplenote"
chmod +x fedy/plugins/simplenote.plugin/install.sh
(cd fedy/plugins/simplenote.plugin/ && sudo su root bash -c ./install.sh)

# Cleanup Fedy
sudo rm -rf fedy

echo "Install Slack"
sudo dnf copr enable jdoss/slack-repo -y
sudo dnf install slack-repo -y
sudo dnf install slack -y

echo "Install spotify"
sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-spotify.repo  
sudo dnf -y install spotify-client 

echo "Install Brave browser"
sudo dnf install -y dnf-plugins-core

sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/

sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

echo "Install Vscode"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

echo "Install Zoom"
sudo rpm -i https://zoom.us/client/latest/zoom_$(uname -m).rpm

# Install Appimages
mkdir -p ~/Applications

echo "Install walc Appimage to Applications"
# wget -c https://github.com/$(wget -q https://github.com/probonopd/go-appimage/releases -O - | grep "appimaged-.*-x86_64.AppImage" | head -n 1 | cut -d '"' -f 2)
wget -c https://github.com/$(wget -q https://github.com/cstayyab/WALC/releases -O - | grep "walc.AppImage" | head -n 1 | cut -d '"' -f 2) -P ~/Applications/
chmod +x ~/Applications/walc.AppImage

