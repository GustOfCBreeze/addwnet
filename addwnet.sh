#!/bin/bash
#
#
#
#	 _____________
#
#	  * addwnet *
#	 _____________   	v1.3
#
#
# add/remove - wireless network config tool
#
# To start initialization, execute this script.
# After initialization is completed, you can simply use the command:
# *addwnet <ssid> <password>* from anywhere on your system to add or
# remove wireless networks. Must be run with root. 
#
# See addwnet -h for help and more details about functions and use.
#
#
#
# by guspi
#
#
#

VERSION="1.3"
PATHPATH="/usr/local/bin/addwnet"
CONFPATH="/etc/wpa_supplicant/wpa_supplicant.conf"
BACKUP_PATH="/etc/wpa_supplicant/wpa_supplicant_backup.conf"
H_PATH="/usr/local/bin/addw_h.md"
BACKUP=""


if [ "$1" == "-h" ]; then
	cat "$H_PATH"
	if [ $? -eq 0 ]; then
		exit 0
	else 
		H_PATH="$(find /home -name addw_h.md)"
		cat "$H_PATH"
		exit 1
	fi
fi

if [ "$(id -u)" != "0" ]; then
    echo "'addwnet' needs to be run with root privilage."
    echo "Please run with sudo."
    echo -e "'addwnet -h'\t for help"
    exit 1
fi


if ! test -e "$PATHPATH"; then
	CURRENT_PATH="$(realpath "$0")"
	HLOC_PATH="$(realpath "addw_h.md")"
	wait
	echo -e "\nInitializing.."
	cp -p "$CURRENT_PATH" "$PATHPATH"
	cp -p "$HLOC_PATH" "/usr/local/bin/addw_h.md"
	cp -p "$CONFPATH" "BACKUP_PATH"
	sleep 1
	if test -e "$PATHPATH"; then
		chmod +x "$PATHPATH"
		echo -e "\n*addwnet* initialized on your system. You can now run this program from any directory and without file extensions.\n"
		echo -e "\nExample: addwnet <ssid> <password>\n\nOr addwnet -h  for help\n"
		exit 0
	else
		echo -e "Initialization not completed. Try to run the script whilst you are in the 'addwnet' directory. Executing addwnet from folder instead..\n"
	fi
fi

if [ "$1" == "restart" ]; then
	read -p "If you are using this device with a wireless connection you will be disconnected. Restart? Y/n:" YNR
	YNR=$(echo "$YNR" | tr '[:upper:]' '[:lower:]')
	if [ "$YNR" == "y" ]; then
		echo "Restarting network services.."
		systemctl restart networking
		exit 0
	else
		exit 1
	fi
elif [ "$1" == "restore" ]; then
	read -p "Do you want to restore your network setting to the state it was before last change? Y/n:" YNB
	YNB=$(echo "$YNB" | tr '[:upper:]' '[:lower:]')
	if [ "$YNB" == "y" ]; then
		echo -e "\nRestoring.."
		cp -f "$BACKUP_PATH" "$CONFPATH" 
		wait
		if [ $? -eq 0 ]; then
			echo -e "Restore successful!\n"
		elif ! test -e "$BACKUP_PATH"; then
			echo "Unable to restore; Backup file not found."
			exit 1
		else
			echo "Unable to restore; Reason unknown."
			exit 1
		fi
	else 
		exit 1
	fi
elif [ "$1" == "-l" ]; then
	echo -e "\nCurrently connected to:\n*SSID: $(iwgetid -r)"
	echo -e "\n-------------------------\n"
	echo -e "Stored wireless networks:\n"
	NETLIST=$(grep -E -e 'ssid="' -e 'priority=' "$CONFPATH" | sed -e '/priority=/ a\\')
	echo -e "$NETLIST\n" | sed -e 's/^[[:blank:]]*//'
	exit 0
fi

if [ $# -lt 2 ]; then
    echo -e "\nCommand: sudo addwnet <SSID> <password> [path] (Default: leave path empty.)\n\nFor help use command: $0 -h\n"
    exit 1
fi

SSID="$1"
PASSWORD="$2"
HIDDEN="\tscan_ssid=1"
NOPW="\tkey_mgmt=NONE\n"


if [ $# -ge 3 ]; then
	if [ "$3" == "-p" ]; then 
		PRIO="\tpriority=$4\n"
	else
    	CONFPATH="$3"
	fi
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

if [ "$PASSWORD" == "-" ]; then
	PSK=$(wpa_passphrase "$SSID" "00000000" | sed '/psk="/d')
	echo "Starting setup for network without password."
else
	if [ "${#PASSWORD}" -gt 7 ]; then
		PSK=$(wpa_passphrase "$SSID" "$PASSWORD" | sed '/psk="/d')
		echo "Generating PSK.."
		wait
	else
		echo -e "\nYour password needs to be between 8 and 63 characters.\n"
		echo "If the problem persists and your credentials include certain symbols like spaces, '$' or '#', use double quotation marks around the password/ssid."
		exit 1
	fi

	if [ -z "$PSK" ]; then
	    echo "Failed to generate PSK."
	    exit 1
	else
	    echo "PSK generated."
	fi
fi

while grep -q -E ".*$SSID.*" "$CONFPATH"; do
	read -p "A stored network with ssid: $SSID already exists. Overwrite, Add or eXit? O/A/x:" OAX
	OAX=$(echo "$OAX" | tr '[:upper:]' '[:lower:]')
	if [ "$OAX" == "x" ]; then
		exit 1
	elif [ "$OAX" == "o" ]; then
		echo "Removing network configuration with SSID: $1 from file"
		BACKUP="$(cat $CONFPATH)"		
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
			echo -e "$BACKUP" > "$BACKUP_PATH"
			echo "Network: "$SSID" has been removed."
			exit
		fi
	elif [ $OAX == "a" ]; then 
		break
	else
		continue
	fi
done



if [ "$PASSWORD" == "-" ]; then
	echo -e "$PSK" | sed -e "/ssid=/a\\" -e "$NOPW$HIDDEN" >> "$CONFPATH"
	echo -e ""$NOPW"\n"$HIDDEN""
elif [ "$3" == "-p" ]; then
	echo -e "$PSK" | sed -e "/ssid=/a\\" -e "$PRIO$HIDDEN" >> "$CONFPATH"
else
	echo -e "$PSK" | sed -e "/ssid=/a\\" -e "$HIDDEN" >> "$CONFPATH"
	echo "Configuring new network..."
	sleep 1
fi

if grep -q "ssid=\"$SSID\"" "$CONFPATH"; then
	echo -e "$BACKUP" > "$BACKUP_PATH"	
	echo -e "\nNetwork "$SSID" has been added successfully.\n"
else
	echo "Failed to add network."
fi
