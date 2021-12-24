#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
if [[ $OSTYPE == 'linux-gnu'* ]]; then
echo "Please wait while the installation takes place..."
sudo echo '' > /dev/null 2>&1
sudo apt install python3 expect && pip install requests || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
fi

if [[ $OSTYPE == 'linux-android'* ]]; then
echo "Please wait while the installation takes place..."
pkg install git gh ncurses-utils expect python gettext -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
pip install requests || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
fi

echo "Installation done successfully, Executing the main.sh script now..."