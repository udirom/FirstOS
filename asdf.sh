#!/bin/zsh

echo "Install asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
source ~/.zshrc

echo "python"

if [ "$(uname)" != "Darwin" ]; then
    asdf plugin add python
    asdf install python latest
    asdf global python $(asdf latest python)
else
    pyenv install 3.9.4
    pyenv global 3.9.4
fi

curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

echo "ipython pipenv"
pip3 install ipython pipenv saws

echo "nodejs"
asdf plugin add nodejs
asdf install nodejs 14.8.2
asdf global nodejs 14.8.2
npm i -g typescript
npm i -g lerna

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

asdf reshim

zsh
