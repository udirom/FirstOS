#!/bin/zsh

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd -P)
source $SCRIPT_DIR/functions.sh

if [ "$(uname)" != "Darwin" ]; then
    error "Not a mac computer, exiting..."
    exit
fi

info "Docker needs to be installed manually at this point"
info "Installing rosetta"
softwareupdate --install-rosetta

if ! command -v brew &> /dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/udiromano/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
alias brew86="arch -x86_64 /usr/local/bin/brew"

brew install gh \
             git \
             openssl \
             readline \
             xz \
             zlib \
             gnupg \
             micro \
             ccze \
             rar \
             fd \
             wget \
             easy-rsa \
             tig \
             jq \
             fzf \
             tmux \
             multitail \
             bat \
             ranger \
             autojump \
             glances \
             cmake \
             lsd \
             neofetch \
             asdf \
             readline \
             sqlite3 \
             xz

brew install --cask firefox \
                    bitwarden \
                    pycharm \
                    webstorm \
                    visual-studio-code \
                    datagrip \
                    spotify \
                    google-chrome \
                    whatsapp \
                    slack \
                    iterm2 \
                    authy \
                    rectangle

brew86 install python@3.7

curl -sLo $HOME/Library/Fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -sLo $HOME/Library/Fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -sLo $HOME/Library/Fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -sLo $HOME/Library/Fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

if ! command -v starship &> /dev/null
then
	echo "Installing starship prompt"
	sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" "" -y
fi

zsh -c "$SCRIPT_DIR/mac_user_setup.sh"