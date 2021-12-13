#!/bin/bash
if [ $OSTYPE == 'linux-gnu' ]; then
sudo echo '' > /dev/null 2>&1
sudo apt install python3 expect && pip install requests
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
fi

if [ $OSTYPE == 'linux-android' ]; then
pkg install gh ncurses-utils expect python3 gettext -y
pip install requests
fi