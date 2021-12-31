# Tata Sky IPTV Playlist Auto-Updater Script
### This repository is for automatically generating playlist for every 24hrs with the same link. You don't need to use any app or anything, You just need to do this one-time setup and you're good to go.

## Prerequisites:
* Linux/Unix System
* You need to have your own GitHub Token
* For Token need to register on GITHUB, After login, Goto Setting=>Developer Options=>Personal access tokens.
 ![image](https://i.ibb.co/4mrVJpv/Github-Actions.png)

* Tata Sky account details (Like Subscriber ID, Tata Sky Account Password, Tata Sky Registered Phone number)

* Your GitHub Email and UserID which you're using now


## Compatibility:
* Linux
* Termux App from [Fdroid](https://f-droid.org/en/packages/com.termux/)
* Windows Subsystem for Linux

## How to use?
* Copy the below script and paste it in the terminal:
```bash
curl -s 'https://raw.githubusercontent.com/Nageshwar128/TataSky-Playlist-AutoUpdater/main/setup.sh' | bash; git clone https://github.com/Nageshwar128/TataSky-Playlist-AutoUpdater; cd TataSky-Playlist-AutoUpdater; bash ./main.sh;
```
* Now, Enter the required details asked there.
* Please wait until the script does the job for you.
* And That's it there you go, After a few seconds you'll be greeted with a new repo created in your account that makes the job of updating the playlist everyday.

Now you don't need to touch anything, It updates the playlist on its own everyday and you only need to Update the playlist in Tivimate.
All the steps above are to be done only for once. Please Star my repo if you've liked my work! :)

## FAQs

**Question.** Does playlist still work if I change Tata Sky Password?

**Answer.** No, It doesn't. Incase you changed your Tata Sky Password, You need to run this script again.
##

**Q.** I'm getting some error even after entering correct details.

**A.** Make sure you've gave necessary permissions for GitHub Token.
##


## Explanation on how this works

This works purely on the basis of GitHub Workflow Actions, So a VERY BIG THANKS to GitHub.
I've created the script where Actions will automatically trigger the workflow everyday for 2:30 AM IST.

The tokens, GitHub email and ID are required because we are basically creating another repo and gists with this script using them.

## Credits

* [Gaurav Thakkar](https://github.com/ForceGT) for his [IPTV Repo](https://github.com/ForceGT/Tata-Sky-IPTV)
* GitHub for their GitHub Actions
* Manohar Kumar for continuos testing




