#!/bin/bash -e
RED='\033[0;31m'
NC='\033[0m'

if [[ $OSTYPE == 'linux-android'* && $(echo "$TERMUX_VERSION" | cut -c 3-5) -ge "117" ]]; then
    pkg install git
    git clone https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater || { rm -rf TataSky-Playlist-AutoUpdater; git clone https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater; }
    cd TataSky-Playlist-AutoUpdater;
    ./main.sh

elif [[ $OSTYPE == 'linux-gnu'* ]]; then
    sudo apt install git
    git clone https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater || { rm -rf TataSky-Playlist-AutoUpdater; git clone https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater; }
    cd TataSky-Playlist-AutoUpdater;
    ./main.sh
elif [[ $(echo "$TERMUX_VERSION" | cut -c 3-5) -le "117" ]]; then
    echo -e "Please use Latest Termux release, i.e, from FDroid (https://f-droid.org/en/packages/com.termux/)";
    exit 1;
else
    echo "Platform not supported"
    exit 1;
fi
