#!/bin/bash



#	 _____________
#
#	  * addwnet *
#	 _____________   	v1.2.24
#
#
# add/remove - wireless network config tool
#
# If the initialization completes you can simply use the command:
# *addwnet <ssid> <password>* from anywhere on your system to add or
# remove wireless networks. Generally must exec as superuser.
#
#
#
# by guspi
#
#
#



PATHPATH="/usr/local/bin/addwnet"

if ! test -e "$PATHPATH"; then
	CURRENT_PATH="$(realpath "$0")"
	echo "Initializing.."
	cp -p "$CURRENT_PATH" "$PATHPATH"
	sleep 1
	if test -e "$PATHPATH"; then
		chmod +x "$PATHPATH"
		echo -e "\n*addwnet* initialized on your system. You can now run this program from any directory and without file extensions.\n"
		echo -e "\nExample: addwnet <ssid> <password>\n\nOr addwnet -h  for help\n"
		exit 0
	else
		echo -e "Initialization did not complete. Run tool with sudo. Attempting to continue..\n"
	fi
fi

if [ "$1" == "-h" ]; then
	echo -e "\f\n\n\t___________________\n\t| *** addwnet *** |\t\t v. 1.2\n\n\nThis tool was created to make it easy to add or remove wireless networks in\nheadless environments.\n\nIt works by generating a pre-shared key with your login information and sets\nup a new block it in the config file."
	echo -e "The program allows you to connect to hidden SSIDs, and if you want to add\na network with identical SSID or have changed the password, you can choose\nto either force add or overwrite the already saved network\n"
	echo -e "*Remember to run it with 'sudo'.* Since some of the functions require elevated\nprivilage, you might encounter problems otherwise.\n\nFIRST TIME USE: run it from the folder(make it an executable if its not) and\nlet the program initialize and inject itself so that it will be able to run\nfrom any dir and without the need for file extensions\n\n"
	echo -e "__________________________________________________________\n\nTo add a network simply use the command: 'addwnet <SSID> <password>'\n\n__________________________________________________________\n\nOTHER USAGE:\n\n\naddwnet <> <> [Path]\t--Only use path if directory is not default(!)\n\n"
	echo -e "-d ,\t  --Used to remove a stored SSID, use '-d' in place of a password"
	echo -e "\n-h ,\t  --Show help menu"
	echo -e "\nEx: addwnet 'ssid' 'pword' '/path/file.conf\'t- If you have a custom config path.\n\n\n\n\t-created by guspi - apr 2024\n\n"
	exit 1
fi

if [ $# -lt 2 ]; then
    echo -e "Command: (sudo) addwnet <SSID> <password> [path] (Default: leave path empty.)\n\nFor help use command: $0 -h\n"
    exit 1
fi

SSID="$1"
PASSWORD="$2"
CONFPATH="/etc/wpa_supplicant/wpa_supplicant.conf"
HIDDEN="\tscan_ssid=1"


if [ $# -ge 3 ]; then
    CONFPATH="$3"
fi

if [ "$2" == "-d"  ]; then
	if grep -q -E ".*$SSID.*" "$CONFPATH"; then
		read -p "Are you sure you want to remove network: "$1"?. Y/n: " YN1
		YN1=$(echo "$YN1" | tr '[:upper:]' '[:lower:]')
		if [ "$YN1" == "y" ]; then
			sed -i "/network={/{:a;N;/}/!ba;/$SSID/d}" "$CONFPATH"
			sed -i '/^$/d' "$CONFPATH"
			if grep -q -E ".*$SSID.*" "$CONFPATH"; then
				echo "Error: Could not remove SSID."
				exit 1
			else
				echo "SSID successfully removed."
				exit 0
			fi
		else
			echo "Exiting.."
			exit 1
		fi
	else
		echo "Could not find network with SSID: "$1"".
		exit 0
	fi
fi


if [ "${#PASSWORD}" -gt 7 ]; then
	PSK=$(wpa_passphrase "$SSID" "$PASSWORD" | sed '/psk="/d')
	echo "Generating PSK.."
	wait
else
	echo -e "Your password needs to be between 8 and 63 characters.\n"
	echo "If the problem persists and your credentials include certain symbols like '$' or '#', try adding double quotation marks around the password/ssid."
	exit 1
fi

if [ -z "$PSK" ]; then
    echo "Failed to generate PSK."
    exit 1
else
    echo "PSK generated."
fi

while grep -q -E ".*$SSID.*" "$CONFPATH"; do
	read -p "A stored network with ssid:$SSID already exists. Overwrite, Add or eXit? O/A/x:" OAX

	OAX=$(echo "$OAX" | tr '[:upper:]' '[:lower:]')
	if [ "$OAX" == "x" ]; then
		exit 1
	elif [ "$OAX" == "o" ]; then
		echo "Removing network configuration with SSID: $1 from file"
		sed -i "/network={/{:a;N;/}/!ba;/$SSID/d}" "$CONFPATH"
		sed -i '/^$/d' "$CONFPATH"
		sleep 1

		if grep -q -E ".*$SSID.*" "$CONFPATH"; then
			read -p "The network could not be removed. Do you want to add anyway? Y/n: " YN
			YN=$(echo "$YN" | tr '[:upper:]' '[:lower:]')
			if [ $YN == "y" ]; then
				break
			elif [ $YN == "n" ]; then
				exit 1
			fi
		else
			echo "Network: "$SSID" has been removed."
		fi
	elif [ $OAX == "a" ]; then 
		break
	else
		continue
	fi
done

echo -e "$PSK" | sed -e "/ssid=/a\\" -e "$HIDDEN" >> "$CONFPATH"
echo "Configuring new network..."
sleep 1

if grep -q "ssid=\"$SSID\"" "$CONFPATH"; then
	echo -e "\nNetwork "$SSID" has been added successfully.\n"
else
	echo "Failed to add network."
fi
