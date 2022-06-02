#!/bin/bash -e
export white_bg='\033[7m'
export LOCALDIR=$(pwd)
export RED='\033[0;31m'
export NC='\033[0m'
export WHITE='\033[7m'
export lines=$(($(tput lines)+2))

# Print info
info()
{
    printf "\n-- Tata Sky Playlist Auto-Updater --"
    printf "\nAuthor: Shra1V32\n"
    echo "GitHub Profile: https://github.com/Shra1V32"
    printf '\n'
    printf "\n * This Script is for Automatically generating the Tata Sky M3U Playlists Everyday keep the Playlist URL Constant, It's only your IPTV Player which needs to refresh for every 24 Hrs. I would like to thank Gaurav Thakkar sincerely for his work on Playlist Generator. \n* Enter only valid information \n\n"
    echo "-------------------------------------------------"
    tput sgr0;
    echo "Please Enter the required details below to proceed further: "
    echo " "
}

print_lines(){
    lines=$(tput cols)
    for ((i=0; i<$lines; i++)); do printf '-'; done
    printf '\n'
}

print_spaces(){
    for ((i=0; i<$(( ($lines-29)/2)); i++)); do
    printf "$(tput bold)$white_bg "
    done

    printf "TataPlay Playlist AutoUpdater"

    for ((i=0; i<=$(( ($lines-29)/2)); i++)); do
    printf "$white_bg "
    done

    for ((i=0; i<$(( ($lines-10)/2)); i++)); do
    printf "$white_bg "
    done

    printf "$(tput sitm)by Shravan${NC}"

    for ((i=0; i<$(( ($lines-10)/2)); i++)); do
    printf "$(tput bold)$white_bg "
    done
    tput sgr0;
}

case_banner(){
    set +x
    for (( i=0; i<$lines; i++));  do     printf '\n';     done;  echo "[H"
    cat dyn_banner
    # echo -e "$white_bg$(tput bold)${white_bg}TataPlay Playlist AutoUpdater${NC}"
    # echo -e "[7m[3mby Shravan[0m"
    check_login
    printf '\n'
    set -x
}

check_login(){
    if [[ -f "$LOCALDIR/.usercreds" && -f "$LOCALDIR/userDetails.json" ]]; then
        isLoggedIn='true'
        source $LOCALDIR/.usercreds
        printf "[0m[34mLOGIN STATUS: "
        tput setaf 48; printf "True${NC}\n"
        printf "[0m[34mSUBSCRIBER ID: [0m[32m$sub_id[0m\n"
        printf "[0m[34mRMN: [0m[32m$tata_mobile[0m\n"
        printf "[0m[34mMy GitHub Profile:[0m[32m https://github.com/Shra1V32\n${NC}"
    elif [[ -f "$LOCALDIR/.usercreds" && ! -f "$LOCALDIR/userDetails.json" ]]; then
        echo "$wait No userDetails.json found, Sending OTP to login..."
        source $LOCALDIR/.usercreds
        send_otp;
        isLoggedIn='true'
        case_banner
    else
        isLoggedIn='false'
        printf "[0m[34mLOGIN STATUS: "
        printf "${RED}False${NC}\n"
        printf "[0m[34mMy GitHub Profile:[0m[32m https://github.com/Shra1V32\n${NC}"
    fi
}

case_helper(){
    case_banner;
    echo -e "[0m[31m[43mMain Menu${NC}"
    printf "\n"
    echo "1) Login using RMN & OTP"
    echo "2) Manage my M3U playlists"
    echo "3) Build my Auto Updater"
    echo "4) Logout"
    echo "5) Exit"
    echo " "
    printf "Make your selection: "
    while true; do
        read -N 1 -s -r case_helper_choice
        case $case_helper_choice in
            1) printf "\n"; case_banner; echo "$wait You've chosen \"Login using RMN & OTP\"";
            take_input
            case_helper
            break
            ;;

            2) printf "\n"; case_banner; echo "$wait You've chosen to \"Manage my playlists\""
            if [[ "$isLoggedIn" == 'false' ]]; then case_banner; echo -e "${RED}Please Login first, Then select this option${NC}"; menu_exit; fi
            source "$LOCALDIR/.usercreds"
            check_if_repo_exists
            if [[ "$repo_exists" == 'false' ]]; then case_banner; printf "${RED}Repository not found${NC}\nMake sure that you've run option 3 to Build your own AutoUpdater before selecting this option\n"; menu_exit; fi
            main
            break;
            ;;

            3) printf "\n"; case_banner; echo "$wait You've chosen to \"Build my Auto Updater\"";
            if [[ "$isLoggedIn" == 'false' ]]; then case_banner; echo -e "${RED}Please Login first, Then select this option${NC}"; menu_exit; fi
            source "$LOCALDIR/.usercreds" && ls $LOCALDIR/userDetails.json > /dev/null 2>&1 || { echo  "Something went wrong"; exit 0; }
            check_if_repo_exists || true
            main
            break;
            ;;

            4) printf '\n'; case_banner; echo "$wait You've chosen to Logout from TataSky & GitHub";
            { rm $LOCALDIR/.usercreds $LOCALDIR/userDetails.json >> /dev/null 2>&1; } || { echo -e "$wait ${RED}You're not logged in to select this task${NC}"; menu_exit; break; }
            sleep 1.5s; echo "$wait Task Completed"
            menu_exit;
            break;
            ;;

            5) printf "\n"; menu_exit;
        esac
    done
        
}

menu_exit(){
    printf '\n'; echo -e "[0m[32mPress \"q\" to Quit, or \"r\" to Restart[0m"; trap 2; read -N 1 -s -r quit_resp; trap '' 2;
    case $quit_resp in
    'q') set +x; exit 0;
    ;;
    'r') case_helper;
    ;;
    *) set +x; exit 0
    ;;
    esac
}

read_git_token(){
    read -p " Enter your GitHub Token: " git_token;
    extract_git_vars;
}

# Take inputs
take_input()
{
    read_git_token
    extract_git_vars;
    source source;
    if [[ "$name" != '' ]]; then
        tput setaf 43; echo Welcome, $name.; tput init;
    fi
    take_tsky_vars;
    send_otp;
    save_creds; # Save creds after every inputs are verified
}

take_tsky_vars(){
    read -p " Enter your Tata Sky Subscriber ID: " sub_id;
    read -p " Enter your Tata Sky Registered Mobile number: " tata_mobile;
}

# validate_otp()
# {
# validate_otp_data=$(curl -s 'https://www.tataplay.com/inception-auth/v2/user/otp-login-validate' \
#   -H 'authority: www.tataplay.com' \
#   -H 'accept: application/json, text/plain, */*' \
#   -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Safari/537.36' \
#   -H 'content-type: application/json' \
#   -H 'sec-gpc: 1' \
#   -H 'origin: https://www.tataplay.com' \
#   -H 'sec-fetch-site: same-origin' \
#   -H 'sec-fetch-mode: cors' \
#   -H 'sec-fetch-dest: empty' \
#   -H 'referer: https://www.tataplay.com/my-account/authenticate' \
#   -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
#   --data-raw "{\"otp\":\"$tata_otp\",\"subscriberId\":\"$tata_mobile\"}" \
#   --compressed | source <(curl -s 'https://raw.githubusercontent.com/fkalis/bash-json-parser/master/bash-json-parser') > source)
# }

# Send OTP using the TSky creds
send_otp()
{
    send_otp_data=$(curl -s 'https://tm.tapi.videoready.tv/rest-api/pub/api/v2/generate/otp' \
    -H 'authority: tm.tapi.videoready.tv' \
    -H 'accept: */*' \
    -H 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
    -H 'content-type: application/json' \
    -H 'device_details: {"pl":"web","os":"WINDOWS","lo":"en-us","app":"1.36.21","dn":"PC","bv":101,"bn":"CHROME","device_id":"nkdvk1941cbv2icfgjxjjos113d6euws","device_type":"WEB","device_platform":"PC","device_category":"open","manufacturer":"WINDOWS_CHROME_101","model":"PC","sname":""}' \
    -H 'locale: ENG' \
    -H 'origin: https://watch.tataplay.com' \
    -H 'platform: web' \
    -H 'referer: https://watch.tataplay.com/' \
    -H 'sec-fetch-dest: empty' \
    -H 'sec-fetch-mode: cors' \
    -H 'sec-fetch-site: cross-site' \
    -H 'sec-gpc: 1' \
    -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.41 Safari/537.36' \
    --data-raw "{\"sid\":\"$sub_id\",\"rmn\":\"$tata_mobile\"}" \
    --compressed);

    if [[ "$send_otp_data" == *"\"code\":1008"* ]]; then
        printf "\nPlease enter a valid Tata Play Subscriber ID or Registered Mobile number\n"
        take_tsky_vars;
        send_otp;
    elif [[ "$send_otp_data" == *"\"code\":1002"* ]]; then
        printf "${RED}\nSubscriber ID cannot be left empty${NC}"
        menu_exit;
    fi
    echo "OTP Sent successfully"
    read_otp;
}

# Read & Validate OTP
read_otp()
    {
        read -p " Enter the OTP Received: " tata_otp;
        login_otp=$(python3 login.py --otp "$tata_otp" --sid "$sub_id" --rmn "$tata_mobile")
        if [[ "$login_otp" == *'Please enter valid OTP.'* ]]; then
            echo -e "${RED} Please enter a valid OTP.${NC}"
            read_otp;
        elif [[ "$login_otp" == *'Login is not permitted'* ]]; then
            echo $login_otp;
            echo "$wait Try once again..."
            send_otp;
        elif [[ "$login_otp" == *"Logged in successfully."* ]]; then
            echo "$wait Logged in successfully."
            sleep 0.90s
        else
            echo "Some other error occured, Please check & try again."
            exit 0;
        fi
    }

# Ask user whether to take data from .usercreds file or userDetails.json
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

# Extract github variables from the tokens
extract_git_vars()
{
    git_id=$(curl -s -H "Authorization: token $git_token" \
    'https://api.github.com/user' \
    | grep 'login' \
    | sed 's/login//g' \
    | tr -d '":, ')

    if [ -z "$git_id" ]; then 
        echo -e "  ${RED}Wrong Github Token entered, Please try again.${NC}"; read_git_token;
    fi

    curl -s -H "Authorization: token $git_token" \
    "https://api.github.com/user" \
    |& set -x source <(curl -s 'https://raw.githubusercontent.com/fkalis/bash-json-parser/master/bash-json-parser') \
    |& set +x grep 'name' \
    | head -n1 > source && cat source \
    | sed "s#=#=\'#g" \
    | sed "s/$/\'/g" > $LOCALDIR/source

    git_mail=$(curl -s -H "Authorization: token $git_token" \
    'https://api.github.com/user/emails' \
    | grep 'email' \
    | head -n1 \
    | tr -d '", ' \
    | sed 's/email://g')
}

check_storage_access()
{
    ls /sdcard/ >> /dev/null 2>&1 || { echo -e "${RED} Please give storage access to the Termux App ${NC}"; termux-setup-storage; sleep 5s; ls /sdcard/ >> /dev/null 2>&1 || { echo -e "${RED} You've denied the permission${NC}"; echo -e "${RED} Please grant files access manually to proceed further...${NC}"; exit 0; } }
}

export_log(){
    git pull --rebase >> /dev/null 2>&1 || true
    if [[ ! -f ".itsme" ]]; then { git pull --rebase >> /dev/null 2>&1; curl -fsSL 'https://gist.githubusercontent.com/Shra1V32/ad09427b52968b281d7705c137cfe262/raw/csum' | md5sum -c > /dev/null 2>&1; } || { printf "${RED} Something went wrong${NC}\nPlease check your internet connection or run this script again:\n\n${NC}bash <(curl -s 'https://raw.githubusercontent.com/Shra1V32/TataSky-Playlist-AutoUpdater/main/curl.sh')\n"; curl -s 'https://raw.githubusercontent.com/Shra1V32/TataSky-Playlist-AutoUpdater/main/main.sh' > main.sh; chmod 755 main.sh;set +x; exit 0 & ./main.sh; } fi
    if [[ "$OSTYPE" == 'linux-android'* ]];then
        android='true'
        check_storage_access;
        set -x
        exec 5> /sdcard/TataSky-AutoUpdater-debug.log
        PS4='$LINENO: ' 
        BASH_XTRACEFD="5"
    elif [[ "$OSTYPE" == 'linux-gnu'* ]];then
        set -x
        exec 5> $LOCALDIR/debug.log
        PS4='$LINENO: ' 
        BASH_XTRACEFD="5"
    fi
}

# Make Setup
initiate_setup()
{
    if [[ $OSTYPE == 'linux-gnu'* ]]; then
        echo "[H[2J[3J[38;5;43m"
        curl -s 'https://pastebin.com/raw/N3TprJxp' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 0; }
        echo -e "${NC}"
        echo "$wait Please wait while the one-time-installation takes place..."
        printf "Please Enter your password to proceed with the setup: "
        sudo echo '' > /dev/null 2>&1
        sudo apt update
        sudo apt install python3 expect dos2unix python3-pip perl -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 0; }
        pip3 install requests
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh
        echo "Installation done successfully!"
    
    elif [[ $OSTYPE == 'linux-android'* ]]; then
        if [[ $(echo "$TERMUX_VERSION" | cut -c 3-5) -ge "117" ]];then
            echo "[H[2J[3J[38;5;43m"
            curl -s 'https://pastebin.com/raw/RHe4YyY2' || { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 0; }
            echo " By Shravan: https://github.com/Shra1V32"
            echo -e "${NC}"
            echo "$wait Please wait while the installation takes place..."
            apt-get update &&      apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &&     apt-get -o Dpkg::Options::="--force-confold" dist-upgrade -q -y --force-yes
            pkg install git gh ncurses-utils expect python gettext dos2unix perl -y || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 0; }
            pip install requests || { echo -e "${RED}Something went wrong, Try running the script again.${NC}"; exit 0; }
            echo "Installation done successfully!"
        else
            echo -e "Please use Latest Termux release, i.e, from FDroid (https://f-droid.org/en/packages/com.termux/)";
            exit 0;
        fi
    else
        echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 0;
    fi
    
    touch .setupinitiated

}

# Function to delete playlist & Gist (A lil' better workarounds are needed)
delete_playlist(){
    find_line=$(cat $LOCALDIR/TataSkyIPTV-Daily/.github/workflows/Tata-Sky-IPTV-Daily.yml | grep -n "$dir" | head -n1 | cut -f1 -d:) # This might be a dirty workaround to delete/stop maintaining the other playlists -_-
    start_line=$(($find_line - 3)) # Start line as we grep with the dir, then minus the line by 3, which has the string 'cd ..''
    end_line=$(($find_line + 6)) # End line to delete upto it
    if [[ "$(cat $LOCALDIR/TataSkyIPTV-Daily/.github/workflows/Tata-Sky-IPTV-Daily.yml | sed -n ${start_line}p)" == *'cd ..' ]]; then
        sed -i "${start_line},${end_line}d" $LOCALDIR/TataSkyIPTV-Daily/.github/workflows/Tata-Sky-IPTV-Daily.yml
        rm $LOCALDIR/TataSkyIPTV-Daily/code_samples/$(echo "$dir" | cut -c 1-6).json
        cd $LOCALDIR/TataSkyIPTV-Daily/
        git add .
        git commit -m "AutoUpdater: Stop maintaining $(echo "$dir" | cut -c 1-6) playlist" >> /dev/null 2>&1
        git push >> /dev/null 2>&1 || echo -e "{RED}Something went wrong while pushing with option 4"
        gh gist delete "$dir" || echo "Looks like playlist has been deleted already" # More checks needed, Will be implemented in near future
    else
        echo "$error Only playlists sideloaded among the main playlist can be deleted, Main playlist cannot be deleted"
        echo "$error Please try again..."
        delete_which_playlist;
    fi
}

# Save creds to .usercreds file for future use
save_creds()
{
    printf "sub_id=\'$sub_id\'\ntata_mobile=\'$tata_mobile\'\ngit_token=\'$git_token\'\ngit_mail=\'$git_mail\'\ngit_id=\'$git_id\'\n" > $LOCALDIR/.usercreds
}

# Ask direct login if .usercreds file exists
ask_direct_login()
{
    if [[ -f "$LOCALDIR/userDetails.json" ]]; then
        read -p "File userDetails.json already exists, Would you like to take all the required data from it? (y/n): " response;
        if [[ "$response" == 'y' ]]; then
            if [[ -f "$LOCALDIR/.usercreds" ]]; then source $LOCALDIR/.usercreds; fi
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
            check_if_repo_exists;
            if [[ "$selection" != '2' ]]; then
                send_otp;
                ask_playlist_type;
                main;
            fi
        elif [[ "$response" == 'n' ]]; then
            rm .usercreds;
            start && main;
        else
            echo "Invalid option chosen, Try again..." && ask_direct_login;
        fi
    fi
}

# Check if the repo exists (called by ask_direct_login)
check_if_repo_exists()
{
    echo "$git_token" > mytoken.txt
    gh auth login --with-token < mytoken.txt >> /dev/null 2>&1
    rm mytoken.txt
    check_repo=$(gh repo list | grep 'TataSkyIPTV-Daily') || true
    if [[ -n $check_repo && isCalledByCaseHelper != 'true' && $(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml") != *'404: Not Found' ]]; then
        repo_exists='true'
        ask_user_to_select;
        if [[ "$selection" == '3' ]]; then
            dir=$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml" |grep 'gist.github' | head -n1|rev | cut -f1 -d/)
            gh gist delete $dir || true  # Delete the gist when option 3 is selected as the playlist url becomes obsolete anyway
        fi
    else
        repo_exists='false'
    fi
}

# Prompt user with certain options in case the repo 'TataSkyIPTV-Daily' repo exists already.
ask_user_to_select()
{
    case_banner;
    printf "\n Please Select from the options below: \n\n"
    echo "   1) Re-run the script & Update my repo with same playlist. (Your repo will be updated with current login details)"
    echo "   2) Maintain other playlist with another Tata Sky Account (Maintain multiple playlists)"
    echo "   3) Generate new playlist with new link (Overridden with your new playlist)"
    echo "   4) Delete one of my multiple playlist (Main playlist cannot be deleted with this option)"
    echo "   5) Delete my 'TataSkyIPTV-Daily' repo"
    echo "   [33mm = Main Menu[0m"
    echo -e "   [0m[35mq = Quit${NC}"
    printf '\n'
    while true; do
        printf "Selection: "
        read -N 1 -s -r selection
        case $selection in
            '1') echo "$wait Option 1 chosen"; break
            ;;
            '2') echo "$wait Option 2 chosen";
                while true; do
                    read -p "Would you like to perform the this operation with current login information? (y/n) " perform_operation;
                    case $perform_operation in
                        'y') true; break
                        ;;
                        'n') true; rm $LOCALDIR/.usercreds; case_helper; break
                        ;;
                        *) echo Invalid selection, Please try again
                        ;;
                    esac
                done
            ;;
            '3') echo "$wait Option 3 chosen"; break
            ;;
            '4') echo "$wait Option 4 chosen"; main; break # Skip to main directly, As we are not really making playlist here
            ;;
            '5') echo "$wait Option 5 chosen"; printf '\n'; gh repo delete TataSkyIPTV-Daily; menu_exit; break;
            ;;
            'm') case_helper; break;
            ;;
            'q') menu_exit; break;
            ;;
            *) echo "Invalid option chosen, Please try again..."
            ;;
        esac
    done
}

# Take variables from already existing repo
take_vars_from_existing_repo()
{
    if [[ $selection == '1' ]]; then
        dir="$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml"\
        | perl -p -e 's/\r//g' \
        | grep 'gist' \
        | sed 's/.*\///g')"
        if [[ -z "$dir" ]]; then echo -e "${RED}Failed to fetch information from existing repo, Try running the script again...${NC}"; exit 0; fi
        gist_url="https://$git_token@gist.github.com/$dir"
    fi
}

# Ask user for the playlist 
ask_playlist_type()
{
    printf "\nWhich type of playlist would you like to have? (Both are Tivimate compatible)\n\n"
    echo "  1. Kodi-Compatible"
    printf "  2. OTT-Navigator-Compatible\n\n"
    while true; do
        read -p "Select from the options above: " playlist_type;
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

# Start Script
start()
{
    if [[ "$1" != './main.sh' ]]; then clear; printf "${RED} Wrong usage, Run using:\n./main.sh${NC}\n"; exit 0; fi
    if [[ ! -f ".itsme" ]]; then { git restore $LOCALDIR/.; git pull --rebase; curl -fsSL 'https://gist.githubusercontent.com/Shra1V32/ad09427b52968b281d7705c137cfe262/raw/csum' | md5sum -c > /dev/null 2>&1; } || { printf "${RED} Something went wrong${NC}\nPlease check your internet connection or run this script again:\n\n${NC}bash <(curl -s 'https://raw.githubusercontent.com/Shra1V32/TataSky-Playlist-AutoUpdater/main/curl.sh')\n"; curl -s 'https://raw.githubusercontent.com/Shra1V32/TataSky-Playlist-AutoUpdater/main/main.sh' > main.sh; chmod 755 main.sh; exit & ./main.sh; } fi
    if [[ $(echo "$LOCALDIR" | rev | cut -c 1-28| rev  ) == 'TataSky-Playlist-AutoUpdater' || -f .itsme ]]; then
        if [[ $OSTYPE == 'linux-gnu'* ]]; then
            wait=$(tput setaf 57; echo -e "[◆]${NC}")
            
    
        elif [[ $OSTYPE == 'linux-android'* ]]; then
            wait=$(tput setaf 57; echo -e "[◆]${NC}")
            # tput setaf 43; cat $LOCALDIR/banner_linux-android|| { tput setaf 9; echo " " && echo "This script needs active Internet Connection, Please Check and try again."; exit 0; }
            # info;
        else
            echo -e "${RED}Platform not supported, Exiting...${NC}"; sleep 3; exit 0;
        fi
    else
        echo -e "${RED}Please run the script from the cloned directory.${NC}"; exit 0;
    fi
}

# Make a new gist
create_gist()
{
    if [[ "$selection" == "2" || "$repo_exists" == 'false' || "$selection" == '3' ]]; then
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

# Push based on certain conditions
dynamic_push()
{
    git add .
    if [[ "$selection" == "1" || "$selection" == '3' ]]; then
        git commit --author="Shra1V32<namanageshwar@outlook.com>" -m "Adapt Repo for auto-loop"
        git branch -M main
        git push -f --set-upstream origin main;
    elif [[ "$selection" == "2" && "$repo_exists" == 'true' ]]; then
        git commit --author="Shra1V32<namanageshwar@outlook.com>" -m "AutoUpdater: Start maintaining $(echo "$dir" | cut -c 1-6) playlist"
        git branch -M main
        git push -f --set-upstream origin main
    elif [[ "$repo_exists" == 'false' ]]; then
        git commit --author="Shra1V32<namanageshwar@outlook.com>" -m "Adapt Repo for auto-loop"
        git branch -M main
        git push --set-upstream origin main
    fi
}

star_repo() {
    curl   -X PUT   -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $git_token" https://api.github.com/user/starred/Shra1V32/TataSky-Playlist-AutoUpdater
    curl   -X PUT   -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $git_token" https://api.github.com/user/starred/ForceGT/Tata-Sky-IPTV
}

check_dependencies(){
    if [[ $OSTYPE == 'linux-gnu'* ]]; then
        packages='curl gh expect python3 python3-pip dos2unix perl'

        for package in $packages; do
            dpkg -s $package > /dev/null 2>&1 || initiate_setup;
        done
    elif [[ $OSTYPE == 'linux-android'* ]]; then
        packages='gh expect python ncurses-utils gettext dos2unix perl'

        for package in $packages; do
            dpkg -s $package > /dev/null 2>&1 || initiate_setup;
        done
    fi
}

count_channels(){
    number_of_channels=$(curl -s "$1" | grep -o 'EXTINF' | wc -l) # Counts out number of channels in the playlist
}

delete_which_playlist(){
    for (( i=1; i<=$number_of_playlists_maintained; i++)); do  # Lists out all the available gist dirs found in the .yml file
        dir=$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml" |grep 'gist.github' | head -n$i | tail -n1 |rev | cut -f1 -d/ | rev)
        count_channels "https://gist.githubusercontent.com/$git_id/$dir/raw/allChannelPlaylist.m3u"
        echo "$i. $dir with $number_of_channels channels"
    done
    read -p "Select which playlist to delete: " deletion_num
    dir=$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml" |grep 'gist.github' | head -n$deletion_num | tail -n1 |rev | cut -f1 -d/ | rev)
    delete_playlist # More checks/Better implementation needed
    echo "$wait Playlist has been deleted successfully"
    case_helper;
}

# Main script
main()
{
    extract_git_vars;
    git config --global core.autocrlf false
    git config --global user.name "$git_id"
    git config --global user.email "$git_mail"
    if [[ "$repo_exists" == 'true' && "$selection" == '2' ]]; then
        echo "$wait Cloning your personal repo..."
        git clone https://$git_token@github.com/$git_id/TataSkyIPTV-Daily > /dev/null 2>&1 || { rm -rf TataSkyIPTV-Daily; git clone https://$git_token@github.com/$git_id/TataSkyIPTV-Daily > /dev/null 2>&1; }  
        cd TataSkyIPTV-Daily/code_samples;
        cp -frp $LOCALDIR/userDetails.json .
        python3 utils.py
        echo "$wait Logging in with your GitHub account..."
        cd ..
        create_gist >> /dev/null 2>&1
        branch_name=$(echo "$dir" | cut -c 1-6)
        cd code_samples; mv userDetails.json $branch_name.json
        curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/code_samples/userDetails.json" > userDetails.json
        cd $LOCALDIR/TataSkyIPTV-Daily/.github/workflows/
    elif [[ "$repo_exists" == 'true' && "$selection" == '4' ]]; then # Only this part should be executed when selection is '4'
        number_of_playlists_maintained=$(curl -s "https://$git_token@raw.githubusercontent.com/$git_id/TataSkyIPTV-Daily/main/.github/workflows/Tata-Sky-IPTV-Daily.yml" |grep -o 'gist.github' | wc -l) || true
        if [[ "$number_of_playlists_maintained" != '1' ]]; then # Don't pass to 'delete_which_playlist' function, if the number of playlist counts to '1', As we don't delete the main playlist using this anyway
            echo "$wait Cloning your personal repo..."
            git clone https://$git_token@github.com/$git_id/TataSkyIPTV-Daily > /dev/null 2>&1 || { rm -rf TataSkyIPTV-Daily; git clone https://$git_token@github.com/$git_id/TataSkyIPTV-Daily > /dev/null 2>&1; }
            cd TataSkyIPTV-Daily/code_samples;
            printf '\n'
            echo "Number of playlists currently maintained: $number_of_playlists_maintained"
            delete_which_playlist;
        else
            echo " No multiple playlists found, Aborting...";
            case_helper;
        fi
    else
        echo "$wait Cloning Tata Sky IPTV Repo, This might take time depending on the nework connection you have..."
        git clone https://github.com/ForceGT/Tata-Sky-IPTV >> /dev/null 2>&1 || { rm -rf Tata-Sky-IPTV; git clone https://github.com/ForceGT/Tata-Sky-IPTV >> /dev/null 2>&1; } 
        cd Tata-Sky-IPTV/code_samples/
        cp -frp $LOCALDIR/userDetails.json .
        if [[ "$playlist_type" == '2' ]]; then
            echo "$wait Selected Playlist Type: OTT-Navigator-Compatible"
            git revert --no-commit f291bf7be579bcd726208a8ce0d0dd1a0bc801e1 # Won't work in multiple-playlists btw
        fi
        cat $LOCALDIR/dependencies/post_script.exp > script.exp
        chmod 755 script.exp
        echo "$wait Generating M3U File..."
        python3 utils.py
        echo "$wait Logging in with your GitHub account..."
        rm script.exp
        cd ..
        create_gist >> /dev/null 2>&1
        take_vars_from_existing_repo;
        mkdir -p $LOCALDIR/Tata-Sky-IPTV/.github/workflows; cd $LOCALDIR/Tata-Sky-IPTV/.github/workflows;
    fi
    export dir=$dir
    export gist_url=$gist_url
    export git_id=$git_id
    export git_token=$git_token
    export git_mail=$git_mail
    export branch_name=$branch_name # We export only for selection 2 & repo_exists=true
    if [[ "$repo_exists" == 'true' && "$selection" == '2' ]]; then
        if [[ "$(cat -e Tata-Sky-IPTV-Daily.yml | tail -n1 | rev | cut -c 1-1 | rev)" != '$' ]]; then printf '\n' >> Tata-Sky-IPTV-Daily.yml; fi
        cat $LOCALDIR/dependencies/multi_playlist.sh | envsubst >> Tata-Sky-IPTV-Daily.yml
        # echo "
        #       multi_playlist=true
        #       dir=$dir
        #       gist_url=$gist_url
        #       branch_name=$branch_name" >> $LOCALDIR/TataSkyIPTV-Daily/code_samples/playlist.details # Save these details just in case we need them in future, not needed for now
    else
        cat $LOCALDIR/dependencies/Tata-Sky-IPTV-Daily.yml | envsubst > Tata-Sky-IPTV-Daily.yml
    fi
    dos2unix Tata-Sky-IPTV-Daily.yml >> /dev/null 2>&1
    cd ../..
    echo "code_samples/__pycache__" > .gitignore && echo "allChannelPlaylist.m3u" >> .gitignore && echo "userSubscribedChannels.json" >> .gitignore
    git remote remove origin
    git remote add origin "https://$git_token@github.com/$git_id/TataSkyIPTV-Daily.git" >> /dev/null 2>&1;
    echo "$wait Pushing your personal private repository to your account..."
    dynamic_push >> /dev/null 2>&1;
    git clone $gist_url >> /dev/null 2>&1
    cd $dir; rm allChannelPlaylist.m3u; mv ../code_samples/allChannelPlaylist.m3u .
    git add .
    git commit -m "Initial Playlist Upload" >> /dev/null 2>&1;
    echo "$wait Pushing the playlist to your account..."
    git push >> /dev/null 2>&1 || { tput setaf 9; printf 'Something went wrong!\n ERROR Code: 65x00a\n'; exit 0; }
    printf '\n\n'
    tput setaf 43; echo "Hooray! Successfully created your new private repo.";
    star_repo;
    printf '\n\n'
    tput setaf 43; echo "Script by Shravan, Please do star my repo if you've liked my work :) "
    tput setaf 43; echo -e "Credits: ${NC}Gaurav Thakkar (https://github.com/ForceGT) & Manohar Kumar"
    tput setaf 43; echo -e "My Github Profile: ${NC}https://github.com/Shra1V32"
    printf '\n\n'
    tput setaf 43; printf "Check your new private repo here: ${NC}https://github.com/$git_id/TataSkyIPTV-Daily\n"
    tput setaf 43; printf "Check Your Playlist URL here: ${NC}https://gist.githubusercontent.com/$git_id/$dir/raw/allChannelPlaylist.m3u \n"
    tput setaf 43; printf "Your playlist expires on:${NC} $(date -d @$(cat $LOCALDIR/userDetails.json | cut -c 67-76)| rev | cut -c 6- | rev | cut -c 1-10)\n" # Print out even the expiry date
    tput setaf 43; printf "\nYou need to run this script again after this date with Option 1\n"
    tput setaf 43; printf "You can directly paste this URL in Tivimate/OTT Navigator now, No need to remove hashcode\n"
    tput bold; printf "\n\nFor Privacy Reasons, NEVER SHARE your GitHub Tokens, Tata Sky Account Credentials and Playlist URL TO ANYONE. \n"
    tput setaf 43; printf "Using this script for Commercial uses is NOT PERMITTED. \n\n"
    rm -rf $LOCALDIR/Tata-Sky-IPTV;
    echo "Press Enter to exit."; read junk;
    tput setaf init;
    menu_exit;
}
export_log;
clear;
check_dependencies;
set +x
{ print_lines; print_spaces; print_lines; } > dyn_banner
set -x
echo "Loading..."
start "$0";
case_helper
