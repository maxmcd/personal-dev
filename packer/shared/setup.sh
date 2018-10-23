#!/bin/bash

set -e

# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

cd /ops

VAULTVERSION=0.10.3
VAULTDOWNLOAD=https://releases.hashicorp.com/vault/${VAULTVERSION}/vault_${VAULTVERSION}_linux_amd64.zip
VAULTCONFIGDIR=/etc/vault.d
VAULTDIR=/opt/vault

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
  curl \
  tmux \
  git \
  build-essential \
  wget \
  tree

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

sudo add-apt-repository ppa:gophers/archive
sudo apt-get update
sudo apt-get install -y golang-1.10-go

curl https://sh.rustup.rs -sSf | sh -s -- -y
cp /ops/shared/bash_profile.bash ~/.bash_profile

cd ~/

wget -O .git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash 
wget -O .git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

mkdir ~/go
mkdir -p ~/go/src/github.com/maxmcd
mkdir ~/go/bin

cd ~ && git clone https://github.com/michaeldfallen/git-radar .git-radar
