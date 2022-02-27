#!/bin/bash -e
if [[ $OSTYPE == 'linux-android'* ]]; then
pkg install git
git clone https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater; || { rm -rf TataSky-Playlist-AutoUpdater; }
cd TataSky-Playlist-AutoUpdater;
bash main.sh
elif [[ $OSTYPE == 'linux-gnu'* ]]; then
git clone https://github.com/Shra1V32/TataSky-Playlist-AutoUpdater;
cd TataSky-Playlist-AutoUpdater;
bash main.sh
fi
