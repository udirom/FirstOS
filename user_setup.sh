# Add user to the docker group
sudo usermod -aG docker $USER

#asdf
asdf plugin add python
asdf install python latest
asdf global python $(asdf latest python)
source ~/.bashrc

pip3 install ipython pipenv

asdf plugin add poetry
asdf install poetry latest
asdf global poetry $(asdf latest poetry)

asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)
npm i -g typescript lerna

#colorls
asdf plugin add exa
asdf install exa latest
asdf global exa $(asdf latest exa)

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

asdf plugin add fd
asdf install fd latest
asdf global fd $(asdf latest fd)

asdf plugin add fzf
asdf install fzf latest
asdf global fzf $(asdf latest fzf)

asdf plugin add vim
asdf install vim latest
asdf global vim $(asdf latest vim)

asdf plugin add tmux
asdf install tmux latest
asdf global tmux $(asdf latest tmux)

asdf plugin add rust
asdf install rust latest
asdf global rust $(asdf latest rust)

asdf plugin add starship
asdf install starship latest
asdf global starship $(asdf latest starship)
echo 'eval "$(starship init bash)"' >> ~/.bashrc
source ~/.bashrc

# bash it + activate plugins
#git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
#~/.bash_it/install.sh
#source ~/.bashrc
#bash-it enable plugin history fzf history-search git docker docker-compose aws autojump
#bashit enable alias git apt curl node vim docker docker-compose kubectl
#bash-it enable completion rustup pip3 pipenv tmux npm lerna helm cargo awscli git docker docker-compose
#source ~/.bashrc

#color ls + aliases

# firefox addons
# clipboard manager
#password manager?



