#!/usr/bin/zsh

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0

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
