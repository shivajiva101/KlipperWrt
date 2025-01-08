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
	
	umount ${DEVICE};

	#mkfs.ext4 /dev/mmcblk0p1;
 	mkfs.ext4 -L extroot ${DEVICE}

}

extroot(){
	echo " "
	sleep 1
	echo -ne 'Making extroot...     [=>                                ](7%)\r'
 	eval $(block info ${DEVICE} | grep -o -e 'UUID="\S*"')
	#uci -q delete fstab.rwm;
	echo -ne 'Making extroot...     [====>                             ](14%)\r'
	eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
 	#uci set fstab.rwm="mount";
	echo -ne 'Making extroot...     [=======>                          ](21%)\r'
	uci -q delete fstab.extroot
 	#uci set fstab.rwm.device="${DEVICE}";
	echo -ne 'Making extroot...     [=========>                        ](28%)\r'
	uci set fstab.extroot="mount"
 	#uci set fstab.rwm.target="/rwm";
	echo -ne 'Making extroot...     [===========>                      ](35%)\r'
	uci set fstab.extroot.uuid="${UUID}"
 	#uci commit fstab;
	echo -ne 'Making extroot...     [===============>                  ](42%)\r'
	uci set fstab.extroot.target="${MOUNT}"
 	#eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*")
	echo -ne 'Making extroot...     [=================>                ](50%)\r'
	uci commit fstab
 	#uci -q delete fstab.overlay;
	echo -ne 'Making extroot...     [===================>              ](57%)\r'
	ORIG="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"
 	#uci set fstab.overlay="mount";
	echo -ne 'Making extroot...     [=====================>            ](64%)\r'
	uci -q delete fstab.rwm
 	#uci set fstab.overlay.uuid="${UUID}";
	echo -ne 'Making extroot...     [=======================>          ](71%)\r'
	uci set fstab.rwm="mount"
 	#uci set fstab.overlay.target="/overlay";
	echo -ne 'Making extroot...     [=========================>        ](78%)\r'
	uci set fstab.rwm.device="${ORIG}"
 	#uci commit fstab;
	echo -ne 'Making extroot...     [===========================>      ](85%)\r'
	uci set fstab.rwm.target="/rwm"
 	#mount S{DEVICE} /mnt;
	echo -ne 'Making extroot...     [=============================>    ](92%)\r'
	uci commit fstab
 	#cp -f -a /overlay/. /mnt;
	echo -ne 'Making extroot...     [===============================>  ](98%)\r'
	mount ${DEVICE} /mnt
 	tar -C ${MOUNT} -cvf - . | tar -C /mnt -xf -
 	#umount /mnt;
	echo -ne 'Making extroot...     [=================================>](100%)\r'
	echo -ne '\n'

	echo "Please reboot then run the second script!";
}

format;
extroot;
