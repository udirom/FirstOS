#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Add user to the docker group
sudo usermod -aG docker $USER

# Flatpaks
sudo flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Ultimate \
	com.jetbrains.DataGrip \
	com.spotify.Client \
	io.bit3.WhatsAppQT \
	org.fedoraproject.MediaWriter \
	us.zoom.Zoom \
	com.slack.Slack \
	com.simplenote.Simplenote \
	org.pulseaudio.pavucontrol \
	org.telegram.desktop

# install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
mv ~/.zshrc ~/.old-zshrc
ln -s $SCRIPT_DIR/dotfiles/.zshrc ~/.zshrc

## Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

sudo chsh -s $(which zsh)

source $SCRIPT_DIR/asdf.sh
