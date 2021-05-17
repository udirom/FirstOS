#!/usr/bin/zsh
echo "Install asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
source ~/.zshrc

echo "python"
asdf plugin add python
asdf install python latest
asdf global python $(asdf latest python)

echo "ipython pipenv"
pip3 install ipython pipenv

echo "poetry"
asdf plugin add poetry
asdf install poetry latest
asdf global poetry $(asdf latest poetry)

echo "nodejs"
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)
npm i -g typescript lerna

echo "sqlite"
asdf plugin add sqlite
asdf install sqlite latest
asdf global sqlite $(asdf latest sqlite)

echo "minikube"
asdf plugin add minikube
asdf install minikube latest
asdf global minikube $(asdf latest minikube)

echo "kubectl"
asdf plugin add kubectl
asdf install kubectl latest
asdf global kubectl $(asdf latest kubectl)

echo "helm"
asdf plugin add helm
asdf install helm latest
asdf global helm $(asdf latest helm)

echo "awscli"
asdf plugin add awscli
asdf install awscli latest
asdf global awscli $(asdf latest awscli)

echo "terraform"
asdf plugin add terraform
asdf install terraform latest
asdf global terraform $(asdf latest terraform)

echo "rust"
asdf plugin add rust
asdf install rust latest
asdf global rust $(asdf latest rust)

zsh
