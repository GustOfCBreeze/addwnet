# addwnet #
v1.3

Addwnet is a tool that lets you add or remove wireless networks quickly in headless linux. It sets up the necessary config files so that your device connects to new networks, including those with hidden SSID.

Its main function is to generate a psk from the	input user login info and set up a new network, but has many other functions. See '-h' in the terminal for more info. 
The tool includes prompts throughout the usage and will inform you about its status. E.g., it will prompt you to choose action if a network already is added(e.g. in case you have a new password for an already stored ssid).


#####################################################

USAGE:

>>> FIRST TIME USE ONLY: <<<
To get started, execute the script file addwnet.sh. If youre in the folder, run the command 'sudo ./addwnet.sh' alternatevly, run 'sudo path/to/addwnet.sh'(Only needed first time use). The script will then initialize and replicate itself into one of your PATH folders so that you can run it from any directory, and without file extensions in the future.

After successfully initializing, the program will run like a normal app and you can:*

*Add a networks: 
addwnet <ssid> <password>

*Remove a network: 
addwnet <ssid> -d

*Include a priority level to a new network when adding:
sudo addwnet <ssid> -p <#>

*List stored networks.
sudo addwnet -l  

*Restart all networking services on your device:
sudo addwnet restart

*Restore your network config file to the state it was before you last edited it with addwnet:
'sudo addwnet restore'

*Change '.conf' path:
sudo addwnet <ssid> <password> [Path]     (Only use this if your wpa directory is not default(!))


To access terminal help:
(sudo) addwnet -h


#####################################################

Troubleshooting:

If you encounter any problems using the script be sure that you are running it with [sudo]. 

Adding SSID with space character in the name will only work if you envelop the name in double quotes. Like this: "network 12ab".

Passwords that contains symbols and spaces like ' ', '#', or '&', should also be enveloped with double quotes. Like this: "p@55_word#"





- created by guspi - 2024
