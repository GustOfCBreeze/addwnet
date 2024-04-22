# addwnet #
v1.2

A simple bash tool that lets you add or remove wireless networks quickly in headless linux. Will set up the config so that your device connects to hidden ssids as well.

Its main function is to generate a psk from the	input user login info and adds it to the wpa file. The tool includes prompts throughout the usage and will inform you about its status. n example, it will prompt you to choose action if a network already is added(e.g. in case you have a new password for an already stored ssid).


#####################################################

USAGE:

To get started, and run the command 'sudo ./addwnet.sh' alternatevly, 'sudo path/to/addwnet.sh'(Only needed first time use). The script will then initialize and replicate itself into one of your PATH folders so that you can run it from any directory, and without file extensions in the future.

after successfully initializing you can add networks simply by entering: 
addwnet <ssid> <password>

To remove a network, enter: 
addwnet <ssid> -d

To access terminal help:
addwnet -h


#####################################################

Troubleshooting:

If you encounter any problems using the script run it with [sudo], since it edits files that require elevated privilages.

If you still have problems, try entering your ssid/password with quotation marks. Especially if you have symbols like '#' or '&' in your inputs



- created by guspi - 2024
