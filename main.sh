#!/bin/bash
LOCALDIR=$(pwd)
RED='\033[0;31m'
NC='\033[0m'

if [ $OSTYPE == 'linux-gnu' ]; then
packages='curl gh expect python3 ncurses-bin'
for package in $packages; do
dpkg -s $package > /dev/null 2>&1 || { echo -e "${RED} $package is not installed, Make sure you've run setup.sh file before running this script.${NC}"; exit 1; }
done

elif [ $OSTYPE == 'linux-android' ]; then
packages='curl gh expect python3 ncurses-utils gettext'
for package in $packages; do
dpkg -s $package > /dev/null 2>&1 || { echo -e "${RED} $package is not installed, Make sure you've run setup.sh file before running this script.${NC}"; exit 1; }
done
fi

tput setaf 6; curl -s -m 1 'https://pastebin.com/raw/N3TprJxp' || { tput setaf 1; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
printf "\n-- Tata Sky Playlist Auto-Updater --"
printf "\nAuthor: Nageshwar128\n"
echo "GitHub Profile: https://github.com/Nageshwar128"
echo "------------------------------------------------------"
tput sgr0;
echo "Enter the required details below: "
echo " "
read -p " Enter your Tata Sky Subscriber ID: " sub_id;
read -p " Enter your Tata Sky Mobile Number: " tata_mobile;
read -p " Enter your Tata Sky Password: " tata_pass;
read -p " Enter your GitHub Email Address: " git_mail;
read -p " Enter your GitHub ID: " git_id;
read -p " Enter your GitHub Token: " git_token;
git config --global user.name "$git_id"
git config --global user.email "$git_mail"
git clone https://github.com/ForceGT/Tata-Sky-IPTV
cd Tata-Sky-IPTV/code_samples/
wget https://gist.githubusercontent.com/Nageshwar128/25e2fcd571fcb9466c3d95b35ba36fa3/raw/script.exp >> /dev/null 2>&1
chmod 755 script.exp
pass=$(echo "$tata_pass" | sed 's#\$#\\\\$#g' )
sed -i "s/PASSWORD/$pass/g" script.exp
sed -i "s/SUB_ID/$sub_id/g" script.exp
sed -i "s/MOB_NO/$tata_mobile/g" script.exp
./script.exp || { echo "Something went wrong."; exit 1; }
rm script.exp
wget https://gist.githubusercontent.com/Nageshwar128/a334ac6d6404045b1c23eaa583e93458/raw/script.exp >> /dev/null 2>&1
chmod 755 script.exp
echo "$git_token" >> mytoken.txt
gh auth login --with-token < mytoken.txt
rm mytoken.txt
cd ..
echo "Initial Test" >> allChannelPlaylist.m3u
gh gist create allChannelPlaylist.m3u | tee gist_link.txt >> /dev/null 2>&1
sed -i "s/gist/$git_token@gist/g" gist_link.txt
gist_url=$(cat gist_link.txt)
dir="${gist_url##*/}"
rm allChannelPlaylist.m3u gist_link.txt
gh repo create TataSkyIPTV-Daily --private -y || echo "New repo has been created"
mkdir -p .github/workflows && cd .github/workflows
wget https://gist.githubusercontent.com/Nageshwar128/9bb06a83b4fb55d744a0099cf34e8b5d/raw/TataSkyDailyWorkflow.yml >> /dev/null 2>&1
wget https://gist.githubusercontent.com/Nageshwar128/469d24f4739c64542c7c4fa074dc95bf/raw/substitute.txt >> /dev/null 2>&1
export dir=$dir
export gist_url=$gist_url
export git_id=$git_id
export git_token=$git_token
export git_mail=$git_mail
cat substitute.txt | envsubst >> TataSkyDailyWorkflow.yml
rm substitute.txt
cd ../..
rm .gitignore
echo "code_samples/__pycache__" > .gitignore && echo "allChannelPlaylist.m3u" >> .gitignore && echo "userSubscribedChannels.json" >> .gitignore
git remote remove origin
git remote add origin https://$git_token@github.com/$git_id/TataSkyIPTV-Daily
git branch -M main default || git branch -M main
git add .
git commit --author="Nageshwar128<namanageshwar@outlook.com>" -m "Adapt Repo for auto-loop"
git push --set-upstream origin main || { echo "Force pushing..."; git push -f --set-upstream origin main; }
git clone ${gist_url} >> /dev/null 2>&1
cd ${dir} && rm allChannelPlaylist.m3u && mv ../code_samples/allChannelPlaylist.m3u .
git add .
git commit -m "Initial Playlist Upload"
git push >> /dev/null 2>&1 || { tput setaf 1; printf 'Something went wrong!\n ERROR Code: 65x00a\n'; exit 1; }
tput setaf 3; echo "Done creating your new repo. " && printf "Check your new private repo here: https://github.com/$git_id/TataSkyIPTV-Daily\n"
tput setaf 2; echo "Script by Nageshwar128, Please do star my repo if you've liked my work :) "
tput setaf 2; echo "Github Profile: https://github.com/Nageshwar128"
rm -rf $LOCALDIR/Tata-Sky-IPTV
sleep 3;
tput setaf init;
