


        ___________________
        | *** addwnet *** |              v. 1.3



This tool simplifies network configuration on headless systems. Functions
include listing, adding, removing and prioritizing wireless networks.

It works by generating a pre-shared key with your login information and sets
up a new wireless connection
The program allows you to connect to hidden SSIDs. If you want to add
a network with identical SSID or have changed the password, you can choose
to either force add or overwrite the already saved network

*Remember to run it with 'sudo'.* Since accessing network configuration files
directly requires root privilages.


        >>> FIRST TIME USE <<<
Execute the addwnet.sh file(make it executable if its not) and let the program
initialize. When ready, you can use it with the commands below.


__________________________________________________________

To add a network use the command: 'sudo addwnet <SSID> <password>'

(!)Enclose your SSID with double quotes if 'space' characters are used(!)

__________________________________________________________


SYNTAX AND COMMANDS:



..<password> [Path]     --Only use path if wpa directory is not default(!)



..<ssid> -        --To add a wireless network without setting a password, enter a single dash '-'.

..<ssid> -d       --Used to remove a stored SSID, use '-d' in place of a password

..<ssid> -p <#>   --Set the priority of a new network.

addwnet -l        --List stored networks.

addwnet -h        --Show help menu

addwnet restart   --Restarts networking services on your device

addwnet restore   --Restores your network config file to the state it was before you last edited it with addwnet.




        -created by guspi - apr 2024

