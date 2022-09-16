#!/bin/sh

# Original MAC address
ORGMAC="DD:22:44:00:AA:BB"

## Network device eth0, eth1, .....  or  wlan0, wlan1, .....
DEV=eth0

## Set MAC temporary (set) or Set and Save MAC (save).
#MACSET=set
MACSET=save

WGET=/usr/bin/wget
BOXIP=http://localhost
LOCATION=/etc/enigma2/hwmac
SETMAC="$ORGMAC"

## The exit command in the next line is only needed (to close the screen) if the script is used in the "hidden" mode.
$WGET -q -O - $BOXIP/web/remotecontrol?command=174 && sleep 2

busybox ip link set addr $SETMAC dev $DEV 2>/dev/null || :

if [ $MACSET = "save" ] ; then
	if [ $DEV = "eth0" ] ; then
		echo "$SETMAC" > $LOCATION
	else
		$WGET -O - -q "$BOXIP/web/message?text=Original%20MAC%20for%20$DEV%20can%20NOT%20be%20set%20permanently%2E\nOnly%20the%20MAC%20for%20network%20device%20eth0%20can%20be%20set%20permanently%20%21%21&type=1&timeout=10" > /dev/null
	fi
fi

CURRENT_MAC="$(ifconfig $DEV | awk '/'$DEV'/  { print $NF }')"
$WGET -O - -q "$BOXIP/web/message?text=Current%20MAC%20address%20of%20network%20device%20$DEV%3A%20$CURRENT_MAC&type=1&timeout=3" > /dev/null

exit
