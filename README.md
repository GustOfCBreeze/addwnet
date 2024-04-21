# addwnet #
v1.2

A simple tool that lets you add or remove wireless networks quickly in headless linux. Will set up the config so that your device connects to hidden ssids as well.

Its main function is to generate a psk from the	input user login info and adds it to the wpa file. The tool includes prompts throughout the usage and will inform you about its status. n example, it will prompt you to choose action if a network already is added(e.g. in case you have a new password for an already stored ssid).


#####################################################

Usage:

Go get started just run the command 'sudo ./addwnet.sh'. The script will initialize and replicate itself into one of your $PATH folders so that you can run it from any directory, and without file extensions.

after initializing you can add networks by simply entering: 
addwnet <ssid> <password>

To remove a network, enter: 
addwnet <ssid> -d

addwnet -h ,   to access help menu.


#####################################################

Troubleshooting:

If you encounter any problems using the script run it with [sudo], since it edits files that require elevated privilages.

If you still have problems, try entering your ssid/password with quotation marks. Especially if you have symbols like '#' or '&' in your inputs



- created by guspi - 2024
