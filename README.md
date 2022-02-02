# Tata Sky IPTV Playlist Auto-Updater Script
### A Script to trigger the GitHub Actions every day to update the Tata Sky Playlist, A 20-second-run from your terminal for all that first one-time setup!

## Prerequisites:
* Linux/Unix System
* You need to have your own GitHub Token
* For Token need to register from [here](https://github.com/settings/tokens)
Generate new token --> Give all the permissions --> save it somewhere securely.

* Tata Sky account details (Like Subscriber ID, Tata Sky Account Password, Tata Sky Registered Phone number)


## Compatibility:
* Linux
* Termux App from [Fdroid](https://f-droid.org/en/packages/com.termux/)
* Windows Subsystem for Linux

## How to use?
* Copy the below script and paste it in the terminal:
```bash
curl -s 'https://raw.githubusercontent.com/Shra1V32/TataSky-Playlist-AutoUpdater/main/curl.sh' > curl.sh; chmod 755 curl.sh; ./curl.sh;
```
* Please wait until the setup is complete.
* Now, Enter the required details asked there.
![image](https://i.ibb.co/1Z9xkL4/Screenshot-2022-01-19-110057.png)
* Please wait until the script does the job for you.
* And That's it there you go, After a few seconds, you'll be greeted with a new repo and your playlist URL created in your account that makes the job of updating the playlist every day.
* Now if you want to reuse the script again, Just simply do the following: 
```bash
cd && cd TataSky-Playlist-AutoUpdater;
./main.sh
```

Now you don't need to touch anything, It updates the playlist on its own every day and you only need to Update the playlist in Tivimate.
All the steps above are to be done only once. Please Star my repo if you've liked my work! :)

## Note:

* In case you changed your Tata Sky Password, You need to run this script again.
* Make sure you've given the necessary permissions for GitHub Token.
* In case you upgraded your DTH Plan and would also want to reflect it into your playlist, Then you might need to run this script again.
##


## Explanation on how this works

This works purely on the basis of GitHub Workflow Actions, So a VERY BIG THANKS to GitHub.
I've created the script where Actions will automatically trigger the workflow every day for 2:30 AM IST.

The tokens, GitHub Email, and ID are required because we are basically creating another repo and gists with this script using them.

## Discussion Group
* [Telegram](https://t.me/tskyiptv)

## Credits

* [Gaurav Thakkar](https://github.com/ForceGT) for his [IPTV Repo](https://github.com/ForceGT/Tata-Sky-IPTV)
* GitHub for their GitHub Actions
* Manohar Kumar for continuos testing




