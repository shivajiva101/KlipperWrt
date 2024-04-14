#!/bin/sh

echo " "
echo "This script mounts an already existing extroot from the microSD card"
echo " "
echo "   #############################################"
echo "   ## Make sure the microSD card is inserted! ##"
echo "   #############################################"
echo " "
read -p "Press [ENTER] to continue...or [ctrl+c] to exit"

extroot(){
	echo " "
	sleep 1
	echo -ne 'Making extroot...     [=>                                ](6%)\r'
	DEVICE="/dev/mmcblk0p1";
    echo -ne 'Making extroot...     [===>                              ](12%)\r'
    eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*");
    echo -ne 'Making extroot...     [=====>                            ](18%)\r'
    uci -q delete fstab.overlay;
    echo -ne 'Making extroot...     [=======>                          ](25%)\r'
    uci set fstab.overlay="mount";
    echo -ne 'Making extroot...     [=========>                        ](31%)\r'
    uci set fstab.overlay.uuid="${UUID}";
    echo -ne 'Making extroot...     [===========>                      ](37%)\r'
    uci set fstab.overlay.target="/overlay";
    echo -ne 'Making extroot...     [=============>                    ](43%)\r'
    uci commit fstab;
    echo -ne 'Making extroot...     [===============>                  ](50%)\r'
    mount /dev/mmcblk0p1 /mnt;
    echo -ne 'Making extroot...     [=================>                ](56%)\r'
    cp -f -a /overlay/. /mnt;
    echo -ne 'Making extroot...     [===================>              ](62%)\r'
    umount /mnt;
    echo -ne 'Making extroot...     [=====================>            ](68%)\r'
    DEVICE="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)";
    echo -ne 'Making extroot...     [=======================>          ](75%)\r'
    uci -q delete fstab.rwm;
    echo -ne 'Making extroot...     [=========================>        ](81%)\r'
    uci set fstab.rwm="mount";
    echo -ne 'Making extroot...     [===========================>      ](87%)\r'
    uci set fstab.rwm.device="${DEVICE}";
    echo -ne 'Making extroot...     [=============================>    ](93%)\r'
    uci set fstab.rwm.target="/rwm";
    echo -ne 'Making extroot...     [=================================>](100%)\r'
    uci commit fstab;
	echo -ne '\n'
}

extroot;
read -p "Press [ENTER] to reboot"
reboot;
