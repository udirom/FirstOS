# Add user to the docker group
sudo usermod -aG docker $USER

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0

#asdf
asdf plugin add python
asdf install python latest
asdf global python $(asdf latest python)

pip3 install ipython pipenv

asdf plugin add poetry
asdf install poetry latest
asdf global poetry $(asdf latest poetry)

asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)
npm i -g typescript lerna

asdf plugin add sqlite
asdf install sqlite latest
asdf global sqlite $(asdf latest sqlite)

asdf plugin add minikube
asdf install minikube latest
asdf global minikube $(asdf latest minikube)
 
asdf plugin add kubectl
asdf install kubectl latest
asdf global kubectl $(asdf latest kubectl)

asdf plugin add helm
asdf install helm latest
asdf global helm $(asdf latest helm)

asdf plugin add awscli
asdf install awscli latest
asdf global awscli $(asdf latest awscli)

asdf plugin add terraform
asdf install terraform latest
asdf global terraform $(asdf latest terraform)

asdf plugin add rust
asdf install rust latest
asdf global rust $(asdf latest rust)


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
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

ln -s SCRIPT_DIR/dotfiles/.zshrc ~/.zshrc

$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

sudo chsh -s $(which zsh)
zsh
