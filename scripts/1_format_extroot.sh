#!/bin/sh

DEVICE="/dev/mmcblk0p1";

echo " "
echo "This script will format your sd card and make it extroot"
echo " "
echo "   ###################################################"
echo "   ## Make sure you've got a microSD card plugged!  ##"
echo "   ###################################################"
echo " "
read -p "Press [ENTER] to continue...or [ctrl+c] to exit"

format(){
	while true; do
	    read -p "This script will format your sdcard. Are you sure about this? [y/n]: " yn
	    case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	    esac
	done
	
	umount /dev/mmcblk0p1;

	mkfs.ext4 /dev/mmcblk0p1;

}

extroot(){
	echo " "
	sleep 1
	echo -ne 'Making extroot...     [=>                                ](7%)\r'
	uci -q delete fstab.rwm;
	echo -ne 'Making extroot...     [====>                             ](14%)\r'
	uci set fstab.rwm="mount";
	echo -ne 'Making extroot...     [=======>                          ](21%)\r'
	uci set fstab.rwm.device="${DEVICE}";
	echo -ne 'Making extroot...     [=========>                        ](28%)\r'
	uci set fstab.rwm.target="/rwm";
	echo -ne 'Making extroot...     [===========>                      ](35%)\r'
	uci commit fstab;
	echo -ne 'Making extroot...     [===============>                  ](42%)\r'
	eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*")
	echo -ne 'Making extroot...     [=================>                ](50%)\r'
	uci -q delete fstab.overlay;
	echo -ne 'Making extroot...     [===================>              ](57%)\r'
	uci set fstab.overlay="mount";
	echo -ne 'Making extroot...     [=====================>            ](64%)\r'
	uci set fstab.overlay.uuid="${UUID}";
	echo -ne 'Making extroot...     [=======================>          ](71%)\r'
	uci set fstab.overlay.target="/overlay";
	echo -ne 'Making extroot...     [=========================>        ](78%)\r'
	uci commit fstab;
	echo -ne 'Making extroot...     [===========================>      ](85%)\r'
	mount S{DEVICE} /mnt;
	echo -ne 'Making extroot...     [=============================>    ](92%)\r'
	cp -f -a /overlay/. /mnt;
	echo -ne 'Making extroot...     [===============================>  ](98%)\r'
	umount /mnt;
	echo -ne 'Making extroot...     [=================================>](100%)\r'
	echo -ne '\n'

	echo "Please reboot then run the second script!";
}

format;
extroot;
