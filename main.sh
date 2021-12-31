#!/bin/bash -e
LOCALDIR=$(pwd)
RED='\033[0;31m'
NC='\033[0m'

take_input()
{
printf "\n-- Tata Sky Playlist Auto-Updater --"
printf "\nAuthor: Nageshwar128\n"
echo "GitHub Profile: https://github.com/Nageshwar128"
echo "-------------------------------------------------"
tput sgr0;
echo "Enter the required details below: "
echo " "
read -p " Enter your Tata Sky Subscriber ID: " sub_id;
read -p " Enter your Tata Sky Mobile Number: " tata_mobile;
read -p " Enter your Tata Sky Password: " tata_pass;
read -p " Enter your GitHub Email Address: " git_mail;
read -p " Enter your GitHub Username: " git_id;
read -p " Enter your GitHub Token: " git_token;
}

if [[ $OSTYPE == 'linux-gnu'* ]]; then
packages='gh expect python3 python3-pip'
for package in $packages; do
dpkg -s $package > /dev/null 2>&1 || { echo -e "${RED} $package is not installed, Make sure you've run setup.sh file before running this script.${NC}"; exit 1; }
done
clear
tput setaf 6; curl -s 'https://pastebin.com/raw/N3TprJxp' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
take_input;

elif [[ $OSTYPE == 'linux-android'* ]]; then
packages='gh expect python ncurses-utils gettext'
for package in $packages; do
dpkg -s $package > /dev/null 2>&1 || { echo -e "${RED} $package is not installed, Make sure you've run setup.sh file before running this script.${NC}"; exit 1; }
done
clear
tput setaf 6; curl -s 'https://pastebin.com/raw/RHe4YyY2' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
take_input;
else
echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 1;
fi

git config --global user.name "$git_id"
git config --global user.email "$git_mail"
git clone https://github.com/ForceGT/Tata-Sky-IPTV || { rm -rf Tata-Sky-IPTV; git clone https://github.com/ForceGT/Tata-Sky-IPTV; } 
cd Tata-Sky-IPTV/code_samples/
curl -s 'https://gist.githubusercontent.com/Nageshwar128/25e2fcd571fcb9466c3d95b35ba36fa3/raw/script.exp' > script.exp
chmod 755 script.exp
pass=$(echo "$tata_pass" | sed 's#\$#\\\\$#g' )
sed -i "s/PASSWORD/$pass/g" script.exp
sed -i "s/SUB_ID/$sub_id/g" script.exp
sed -i "s/MOB_NO/$tata_mobile/g" script.exp
./script.exp || { echo "Something went wrong."; exit 1; }
curl -s 'https://gist.githubusercontent.com/Nageshwar128/a334ac6d6404045b1c23eaa583e93458/raw/script.exp' > script.exp
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
curl -s 'https://gist.githubusercontent.com/Nageshwar128/9bb06a83b4fb55d744a0099cf34e8b5d/raw/TataSkyDailyWorkflow.yml' > TataSkyDailyWorkflow.yml
curl -s 'https://gist.githubusercontent.com/Nageshwar128/469d24f4739c64542c7c4fa074dc95bf/raw/substitute.txt' > substitute.txt
export dir=$dir
export gist_url=$gist_url
export git_id=$git_id
export git_token=$git_token
export git_mail=$git_mail
cat substitute.txt | envsubst >> TataSkyDailyWorkflow.yml
rm substitute.txt
cd ../..
echo "code_samples/__pycache__" > .gitignore && echo "allChannelPlaylist.m3u" >> .gitignore && echo "userSubscribedChannels.json" >> .gitignore
git remote remove origin
git remote add origin "https://$git_token@github.com/$git_id/TataSkyIPTV-Daily.git"
git branch -M main default || git branch -M main
git add .
git commit --author="Nageshwar128<namanageshwar@outlook.com>" -m "Adapt Repo for auto-loop"
git push --set-upstream origin main || { echo "Normal push failed, Trying to Force Push..."; git push -f --set-upstream origin main; }
git clone ${gist_url} >> /dev/null 2>&1
cd ${dir} && rm allChannelPlaylist.m3u && mv ../code_samples/allChannelPlaylist.m3u .
git add .
git commit -m "Initial Playlist Upload"
git push >> /dev/null 2>&1 || { tput setaf 9; printf 'Something went wrong!\n ERROR Code: 65x00a\n'; exit 1; }
tput setaf 27; echo "Successfully created your new private repo." && printf "Check your new private repo here: ${NC}https://github.com/$git_id/TataSkyIPTV-Daily\n" && tput setaf 27; printf "Check Your Playlist URL here: ${NC}https://gist.githubusercontent.com/$git_id/$dir/raw/allChannelPlaylist.m3u \n" && tput setaf 27; printf "You can directly paste this URL in Tivimate/OTT Navigator now, No need to remove hashcode\n"
tput bold; printf "\n\nFor Privacy Reasons, NEVER SHARE your GitHub Tokens, Tata Sky Account Credentials and Playlist URL TO ANYONE. \n"
tput setaf 27; printf "Using this script for Commercial uses is NOT PERMITTED. \n\n"
tput setaf 2; echo "Script by Nageshwar128, Please do star my repo if you've liked my work :) "
tput setaf 2; echo "Credits: Gaurav Thakkar (https://github.com/ForceGT) & Manohar Kumar"
tput setaf 2; echo "My Github Profile: https://github.com/Nageshwar128"
echo " " && echo " "
rm -rf $LOCALDIR/Tata-Sky-IPTV
echo "Press Enter to exit."; read junk;
tput setaf init;
