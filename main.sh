#!/bin/bash -e
LOCALDIR=$(pwd)
RED='\033[0;31m'
NC='\033[0m'
wait=$(tput setaf 57; echo -e "[◆]${NC}")

## Print info
info()
{
    printf "\n-- Tata Sky Playlist Auto-Updater --"
    printf "\nAuthor: Shra1V32\n"
    echo "GitHub Profile: https://github.com/Shra1V32"
    printf '\n'
    printf "\n * This Script is for Automatically generating the Tata Sky M3U Playlists Everyday keep the Playlist URL Constant, It's only your IPTV Player which needs to refresh for every 24 Hrs. I would like to thank Gaurav Thakkar sincerely for his work on Playlist Generator. \n* Enter only valid information \n\nNow, Get ready to dwell into this journey. \n"
    echo "-------------------------------------------------"
    tput sgr0;
    curl -s "https://raw.githubusercontent.com/ForceGT/Tata-Sky-IPTV/master/code_samples/constants.py" > constants.py &
    curl -s "https://raw.githubusercontent.com/ForceGT/Tata-Sky-IPTV/master/code_samples/login.py" > login.py &
    echo "Please Enter the required details below to proceed further: "
    echo " "
}

## Take inputs
take_input()
{
    read -p " Enter your GitHub Token: " git_token;
    extract_git_vars;
    source source;
    if [[ "$name" != '' ]]; then
    tput setaf 43; echo Welcome, $name.; tput init;
    fi
    send_otp;
}

## validate_otp()
## {
## validate_otp_data=$(curl -s 'https://www.tataplay.com/inception-auth/v2/user/otp-login-validate' \
##   -H 'authority: www.tataplay.com' \
##   -H 'accept: application/json, text/plain, */*' \
##   -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Safari/537.36' \
##   -H 'content-type: application/json' \
##   -H 'sec-gpc: 1' \
##   -H 'origin: https://www.tataplay.com' \
##   -H 'sec-fetch-site: same-origin' \
##   -H 'sec-fetch-mode: cors' \
##   -H 'sec-fetch-dest: empty' \
##   -H 'referer: https://www.tataplay.com/my-account/authenticate' \
##   -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
##   --data-raw "{\"otp\":\"$tata_otp\",\"subscriberId\":\"$tata_mobile\"}" \
##   --compressed | source <(curl -s 'https://raw.githubusercontent.com/fkalis/bash-json-parser/master/bash-json-parser') > source)
## }

## Send OTP using the TSky creds
send_otp()
{
    read -p " Enter your Tata Sky Subscriber ID: " sub_id;
    read -p " Enter your Tata Sky Registered Mobile number: " tata_mobile;
    send_otp_data=$(curl -s "https://kong-tatasky.videoready.tv/rest-api/pub/api/v1/rmn/$tata_mobile/otp");
    if [[ "$send_otp_data" == *"\"code\":1008"* ]]; then
    printf "\nPlease enter a valid Tata Play Subscriber ID or Registered Mobile number\n"
    send_otp;
    fi
    echo "OTP Sent successfully"
    read_otp() {
    read -p " Enter the OTP Received: " tata_otp;
    login_otp=$(python3 login.py --otp "$tata_otp" --sid "$sub_id" --rmn "$tata_mobile")
    if [[ "$login_otp" == *'Please enter valid OTP.'* ]]; then
    echo -e "${RED} Please enter a valid OTP.${NC}"
    read_otp;
    fi
    }
    read_otp;
}

## Ask user whether to take data from .usercreds file or userDetails.json
take_vars()
{
    if [[ -f "$LOCALDIR/userDetails.json" ]]; then
    echo "$wait userDetails.json found in the local directory, Skipping login...";
    ask_direct_login;
    fi
    if [[ ! -f "$LOCALDIR/.usercreds" ]]; then
    take_input;
    ask_playlist_type;
    main;
    else
    ask_direct_login;
    sleep 3;
    fi
}

## Extract github variables from the tokens
extract_git_vars()
{
    git_id=$(curl -s -H "Authorization: token $git_token"     https://api.github.com/user | grep 'login' | sed 's/login//g' | tr -d '":, ')
    if [ -z "$git_id" ]; then echo -e "  ${RED}Wrong Github Token entered, Please try again.${NC}"; take_vars; fi
    curl -s -H "Authorization: token $git_token"     https://api.github.com/user | source <(curl -s 'https://raw.githubusercontent.com/fkalis/bash-json-parser/master/bash-json-parser') | grep 'name' | head -n1 > source && cat source | sed "s#=#=\'#g" | sed "s/$/\'/g" > $LOCALDIR/source
    git_mail=$(curl -s -H "Authorization: token $git_token"     https://api.github.com/user/emails | grep 'email' | head -n1 | tr -d '", ' | sed 's/email://g')
}

## Make Setup
initiate_setup()
{
    if [[ $OSTYPE == 'linux-gnu'* ]]; then
    echo "$wait Please wait while the one-time-installation takes place..."
    printf "Please Enter your password to proceed with the setup: "
    sudo echo '' > /dev/null 2>&1
    sudo apt update
    sudo apt install python3.9 expect dos2unix -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3.9 get-pip.py
    pip3.9 install requests
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
    echo "Installation done successfully!"
    
    elif [[ $OSTYPE == 'linux-android'* ]]; then
    if [[ $(echo "$TERMUX_VERSION" | cut -c 3-5) -ge "117" ]];then
    echo "$wait Please wait while the installation takes place..."
    apt-get update &&      apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &&     apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -q -y --force-yes
    pkg install git gh ncurses-utils expect python gettext dos2unix -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
    pip install requests || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 1; }
    echo "Installation done successfully!"
    else
    echo -e "Please use Latest Termux release, i.e, from FDroid (https://f-droid.org/en/packages/com.termux/)";
    exit 1;
    fi
    else
    echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 1;
    fi
    
    touch .setupinitiated

}

## Save creds to .usercreds file for future use
save_creds()
{
    if [[ ! -f "$LOCALDIR/.usercreds" ]]; then
    echo "$wait Saving usercreds so that you don't have to login again..."
    printf "sub_id=\'$sub_id\'\ntata_mobile=\'$tata_mobile\'\ngit_token=\'$git_token\'\n" > $LOCALDIR/.usercreds
    fi
}

## Ask direct login if .usercreds file exists
ask_direct_login()
{
    if [[ -f "$LOCALDIR/userDetails.json" ]]; then
    read -p "File userDetails.json already exists, Would you like to take all the required data from it? (y/n): " response;
    if [[ "$response" == 'y' ]]; then
    read -p " Enter your GitHub Token: " git_token;
    extract_git_vars;
    source source;
    if [[ "$name" != '' ]]; then
    tput setaf 43; echo Welcome, $name.; tput init;
    fi
    ask_playlist_type;
    main;
    elif [[ "$response" == 'n' ]]; then
    mv userDetails.json .userDetails.json 
    start && main;
    else
    echo "Invalid option chosen, Try again..." && ask_direct_login;
    fi
    fi

    if [[ -f "$LOCALDIR/.usercreds" ]]; then
    read -p "File .usercreds already exists, Would you like to take all the inputs from it? (y/n): " response;
    if [[ "$response" == 'y' ]]; then
    source $LOCALDIR/.usercreds
    send_otp;
    ask_playlist_type;
    main;
    elif [[ "$response" == 'n' ]]; then
    rm .usercreds;
    start && main;
    else
    echo "Invalid option chosen, Try again..." && ask_direct_login;
    fi
    fi
}

## Check if the repo exists
check_if_repo_exists()
{
    check_repo=$(curl -i -s -H "Authorization: token $git_token"     https://api.github.com/user/repos | grep 'TataSkyIPTV-Daily') || true
    if [[ -n $check_repo ]]; then
    repo_exists='true'
    ask_user_to_select;
    else
    repo_exists='false'
    fi
}

## Prompt user with certain options in case the repo 'TataSkyIPTV-Daily' repo exists already.
ask_user_to_select()
{
    printf "\n Repo named 'TataSkyIPTV-Daily' already exists, What would you like to perform? \n\n"
    echo "   1. Re-run the script & Update my repo with same playlist."
    echo "   2. Maintain other playlist with another Tata Sky Account"
    echo "   3. Generate new playlist with new link"
    printf '\n'
    while true; do
    read -p "Select from the options above: " selection
    case $selection in
        '1') echo "$wait Option 1 chosen"; break
        ;;
        '2') echo "$wait Option 2 chosen"; break
        ;;
        '3') echo "$wait Option 3 chosen"; break
        ;;
        *) echo "Invalid option chosen, Please try again..."
        ;;
    esac
    done
}

## Take variables from already existing repo
take_vars_from_existing_repo()
{
    if [[ $selection == '1' ]]; then
    dir="$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml" | perl -p -e 's/\r//g' | grep 'gist' | sed 's/.*\///g')"
    gist_url="https://$git_token@gist.github.com/$dir"
    fi
}

## Ask user for the playlist 
ask_playlist_type()
{
    printf "\nWhich type of playlist would you like to have? (Both are Tivimate compatible)\n\n"
    echo "  1. Kodi Compatible"
    printf "  2. OTT Navigator Compatible\n\n"
    read -p "Select from the options above: " playlist_type;
    while true; do
    case $playlist_type in
    '1') echo "$wait Option 1 chosen"; break
    ;;
    '2') echo "$wait Option 2 chosen"; break
    ;;
    *) echo "Invalid option chosen, Please try again..."
    ;;
    esac
    done
}

## Start Script
start()
{
    git pull https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater.git
    if [[ $OSTYPE == 'linux-gnu'* ]]; then
    packages='curl gh expect python3 python3-pip dos2unix'
    for package in $packages; do
    dpkg -s $package > /dev/null 2>&1 || initiate_setup;
    done
    clear
    tput setaf 43; curl -s 'https://pastebin.com/raw/N3TprJxp' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
    info;
    python='python3.9'
    take_vars;
    
    
    elif [[ $OSTYPE == 'linux-android'* ]]; then
    packages='gh expect python ncurses-utils gettext dos2unix'
    for package in $packages; do
    dpkg -s $package > /dev/null 2>&1 || initiate_setup;
    done
    clear
    tput setaf 43; curl -s 'https://pastebin.com/raw/RHe4YyY2' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 1; }
    info;
    python='python3'
    take_vars;
    else
    echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 1;
    fi
}

## Make a new gist
create_gist()
{
    if [[ $selection == "2" || $repo_exists == 'false' || $selection == '3' ]]; then
    echo "Initial Test" >> allChannelPlaylist.m3u
    echo "$wait Uploading the playlist to Gist..."
    gh gist create allChannelPlaylist.m3u | tee gist_link.txt >> /dev/null 2>&1
    sed -i "s/gist/$git_token@gist/g" gist_link.txt
    gist_url=$(cat gist_link.txt)
    dir="${gist_url##*/}"
    rm allChannelPlaylist.m3u gist_link.txt
    gh repo create TataSkyIPTV-Daily --private -y >> /dev/null 2>&1 || true
    fi
}

## Push based on certain conditions
dynamic_push()
{
    git add .
    git commit --author="Shra1V32<namanageshwar@outlook.com>" -m "Adapt Repo for auto-loop"
    if [[ "$selection" == "1" || "$selection" == '3' ]]; then
    git branch -M main
    git push -f --set-upstream origin main;
    elif [[ "$selection" == "2" ]]; then
    branch_name=$(echo "$dir" | cut -c 1-6)
    git branch -M $branch_name
    git push -f --set-upstream origin $branch_name
    elif [[ "$repo_exists" == 'false' ]]; then
    git branch -M main
    git push --set-upstream origin main
    fi
}

star_repo() {
    curl   -X PUT   -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $git_token" https://api.github.com/user/starred/Shra1V32/TataSky-Playlist-AutoUpdater
}

## Main script
main()
{
    extract_git_vars;
    git config --global core.autocrlf false
    git config --global user.name "$git_id"
    git config --global user.email "$git_mail"
    check_if_repo_exists;
    echo "$wait Cloning Tata Sky IPTV Repo, This might take time depending on the nework connection you have..."
    git clone https://github.com/ForceGT/Tata-Sky-IPTV >> /dev/null 2>&1 || { rm -rf Tata-Sky-IPTV; git clone https://github.com/ForceGT/Tata-Sky-IPTV >> /dev/null 2>&1; } 
    cd Tata-Sky-IPTV/code_samples/
    cp -frp $LOCALDIR/userDetails.json .
    if [[ "$playlist_type" == '2' ]]; then echo "$wait Selected Playlist Type: Kodi & Tivimate Compatible"; git revert --no-commit f291bf7be579bcd726208a8ce0d0dd1a0bc801e1; fi
    cat $LOCALDIR/dependencies/post_script.exp > script.exp
    chmod 755 script.exp
    echo "$wait Generating M3U File..."
    python3 utils.py
    echo "$git_token" >> mytoken.txt
    echo "$wait Logging in with your GitHub account..."
    gh auth login --with-token < mytoken.txt >> /dev/null 2>&1
    rm mytoken.txt script.exp
    cd ..
    create_gist >> /dev/null 2>&1
    take_vars_from_existing_repo >> /dev/null 2>&1
    mkdir -p $LOCALDIR/Tata-Sky-IPTV/.github/workflows; cd $LOCALDIR/Tata-Sky-IPTV/.github/workflows; 
    export dir=$dir
    export gist_url=$gist_url
    export git_id=$git_id
    export git_token=$git_token
    export git_mail=$git_mail
    cat $LOCALDIR/dependencies/Tata-Sky-IPTV-Daily.yml | envsubst > Tata-Sky-IPTV-Daily.yml
    dos2unix Tata-Sky-IPTV-Daily.yml >> /dev/null 2>&1
    cd ../..
    echo "code_samples/__pycache__" > .gitignore && echo "allChannelPlaylist.m3u" >> .gitignore && echo "userSubscribedChannels.json" >> .gitignore
    echo "$wait Preparing to push your personal private repository to your account..."
    git remote remove origin
    git remote add origin "https://$git_token@github.com/$git_id/TataSkyIPTV-Daily.git" >> /dev/null 2>&1;
    dynamic_push >> /dev/null 2>&1;
    git clone $gist_url >> /dev/null 2>&1
    cd $dir; rm allChannelPlaylist.m3u; mv ../code_samples/allChannelPlaylist.m3u .
    git add .
    git commit -m "Initial Playlist Upload" >> /dev/null 2>&1;
    echo "$wait Pushing the repository to your account, This might take a while depending upon the Network Connection..."
    git push >> /dev/null 2>&1 || { tput setaf 9; printf 'Something went wrong!\n ERROR Code: 65x00a\n'; exit 1; }
    save_creds;
    printf '\n\n'
    tput setaf 43; echo "Hooray! Successfully created your new private repo.";
    while true; do
    read -p "$wait Would you like to star 'TataSky-Playlist-AutoUpdater' Script? (It really motivates me to do more cool stuffs, So do consider it by typing 'y'): " read_star;
    case $read_star in
        Y|y) echo "$wait You've chosen \"Yes\". Thank You."; star_repo; break;
        ;;
        N|n) echo "$wait You've chosen \"No\". "; break;
        ;;
        *) echo "Invalid selection, Please try again..."
        ;;
    esac
    done
    printf '\n\n'
    tput setaf 43; echo "Script by Shravan, Please do star my repo if you've liked my work :) "
    tput setaf 43; echo -e "Credits: ${NC}Gaurav Thakkar (https://github.com/ForceGT) & Manohar Kumar"
    tput setaf 43; echo -e "My Github Profile: ${NC}https://github.com/Shra1V32"
    printf '\n\n'
    tput setaf 43; printf "Check your new private repo here: ${NC}https://github.com/$git_id/TataSkyIPTV-Daily\n" && tput setaf 43; printf "Check Your Playlist URL here: ${NC}https://gist.githubusercontent.com/$git_id/$dir/raw/allChannelPlaylist.m3u \n"
    if [[ "$selection" == '2' ]]; then tput setaf 43; echo -e "Check your other playlist branch here: ${NC}https://github.com/$git_id/TataSkyIPTV-Daily/tree/$dir"; fi
    tput setaf 43; printf "You can directly paste this URL in Tivimate/OTT Navigator now, No need to remove hashcode\n"
    tput bold; printf "\n\nFor Privacy Reasons, NEVER SHARE your GitHub Tokens, Tata Sky Account Credentials and Playlist URL TO ANYONE. \n"
    tput setaf 43; printf "Using this script for Commercial uses is NOT PERMITTED. \n\n"
    rm -rf $LOCALDIR/Tata-Sky-IPTV;
    echo "Press Enter to exit."; read junk;
    tput setaf init;
    exit 1;
}
start;
