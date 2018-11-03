#!/bin/bash

ls -lah /home/maxm/.ssh

set -e

# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

cd /ops

# Dependencies
echo "Hashimoto says sleep!"
sleep 10 #https://github.com/hashicorp/packer/issues/2143#issuecomment-106956045

sudo apt-get install -y software-properties-common
sudo apt-get update
sudo apt-get install -y \
  unzip \
  tree \
  redis-tools \
  jq \
  gnupg2 \
  curl \
  tmux \
  git \
  build-essential \
  wget \
  aria2 \
  cmake \
  python \
  python3-dev \
  ruby \
  tree

cp /ops/shared/bash_profile.bash ~/.bash_profile

git config --global user.email "max.t.mcdonnell@gmail.com"
git config --global user.name "maxmcd"

# /home/maxm
cd ~/

# Install vim-sublime
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
curl https://raw.githubusercontent.com/grigio/vim-sublime/master/vimrc > $HOME/.vimrc

# https://github.com/VundleVim/Vundle.vim/issues/511#issuecomment-134251209
echo | echo | vim +PluginInstall +qall &>/dev/null

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

wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
sudo mv terraform /usr/local/bin


git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

sudo add-apt-repository ppa:gophers/archive
sudo apt-get update
sudo apt-get install -y golang-1.10-go

curl https://sh.rustup.rs -sSf | sh -s -- -y

# allow me to ssh into myself
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

wget -O .git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash 
wget -O .git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

mkdir ~/go
mkdir -p ~/go/src/github.com/maxmcd
mkdir -p ~/go/src/github.com/voltusdev
mkdir ~/go/bin

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
