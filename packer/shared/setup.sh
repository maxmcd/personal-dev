#!/bin/bash

set -e

echo $HOME

ls -lah /home/maxm/.ssh

# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

cd /ops

# Dependencies
echo "Hashimoto says sleep!"
sleep 10 #https://github.com/hashicorp/packer/issues/2143#issuecomment-106956045

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-get install -y \
  aria2 \
  build-essential \
  cmake \
  curl \
  git \
  gnupg2 \
  httpie \
  jq \
  python \
  python3-dev \
  python3-pip \
  redis-tools \
  ruby \
  tmux \
  tree \
  unzip \
  nginx \
  wget \
  vim \
  `# line ending`

cp /ops/shared/bash_profile.bash ~/.bash_profile

sudo cp /ops/shared/oauth.conf /etc/nginx/conf.d
sudo nginx -t
sudo service nginx start

git config --global user.email "max.t.mcdonnell@gmail.com"
git config --global user.name "maxmcd"

# /home/maxm
cd ~/

sudo add-apt-repository ppa:gophers/archive
sudo apt-get update
sudo apt-get install -y golang-1.10-go
mkdir ~/go
mkdir -p ~/go/src/github.com/maxmcd
mkdir -p ~/go/src/github.com/voltusdev
mkdir ~/go/bin

git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

GOPATH=/home/maxm/go /usr/lib/go-1.10/bin/go get github.com/bitly/oauth2_proxy
sudo cp /ops/shared/oauth2_proxy.service /etc/systemd/system/oauth2_proxy.service
sudo systemctl start oauth2_proxy.service
GOPATH=/home/maxm/go /usr/lib/go-1.10/bin/go get github.com/yudai/gotty
sudo cp /ops/shared/gotty.service /etc/systemd/system/gotty.service
sudo systemctl start gotty.service

# Install vim-sublime
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mv /ops/shared/vimrc $HOME/.vimrc

# https://github.com/VundleVim/Vundle.vim/issues/511#issuecomment-134251209
echo | echo | vim +PluginInstall +qall 

cd ~/.vim/bundle/YouCompleteMe
python3 install.py
cd ~

git clone https://github.com/flazz/vim-colorschemes
mv vim-colorschemes/colors/ .vim
rm -rf vim-colorschemes

wget https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip
unzip packer_1.3.2_linux_amd64.zip 
sudo mv packer /usr/local/bin

wget https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip
unzip nomad_0.8.6_linux_amd64.zip
sudo mv nomad /usr/local/bin


git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

curl https://sh.rustup.rs -sSf | sh -s -- -y

# allow me to ssh into myself
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

wget -O .git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash 
wget -O .git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

cd ~ && git clone https://github.com/michaeldfallen/git-radar .git-radar

wget https://github.com/sharkdp/bat/releases/download/v0.8.0/bat_0.8.0_amd64.deb
sudo dpkg -i bat_0.8.0_amd64.deb
rm bat_0.8.0_amd64.deb


# Install ruby
# gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# \curl -sSL https://get.rvm.io | bash -s stable
# source /home/maxm/.rvm/scripts/rvm
# rvm install 2.6

# gcloud auth login
# gcloud auth application-default login
