#!/bin/sh

if mount | grep "/dev/mmcblk0p1 on /overlay type ext4" > /dev/null; then

set -e

echo " "
echo "   ######################################################"
echo "   ## Make sure you have a stable Internet connection! ##"
echo "   ######################################################"
echo " "
read -p "Press [ENTER] to Continue ...or [ctrl+c] to exit"

FILE=/overlay/swap.page

if [ ! -f "$FILE" ]; then
echo " "
echo "   #################"
echo "   ###   SWAP    ###"
echo "   #################"
echo " "

echo "Creating swap file"
dd if=/dev/zero of=/overlay/swap.page bs=1M count=512;
echo "Enabling swap file"
mkswap /overlay/swap.page;
swapon /overlay/swap.page;
mount -o remount,size=256M /tmp;

echo "Updating rc.local for swap"
rm /etc/rc.local;
cat << "EOF" > /etc/rc.local
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

###activate the swap file on the SD card
swapon /overlay/swap.page

###expand /tmp space
mount -o remount,size=256M /tmp

exit 0
EOF

fi

echo "Store opkg lists in extroot overlay to preserve memory"
sed -i -e "/^lists_dir\s/s:/var/opkg-lists$:/usr/lib/opkg/lists:" /etc/opkg.conf;

echo " "
echo "   ############################"
echo "   ### Klipper dependencies ###"
echo "   ############################"
echo " "

echo "Installing klipper dependencies..."

opkg update && opkg install git-http unzip htop;
opkg install --force-overwrite gcc;
opkg install patch;

opkg install python3 python3-pip python3-cffi python3-dev python3-greenlet;
pip install --upgrade pip;
pip install --upgrade setuptools;
pip install -r klippy-requirements.txt;

echo "Cloning 250k baud pyserial"
git clone https://github.com/pyserial/pyserial /root/pyserial;
cd /root/pyserial
python /root/pyserial/setup.py install;
cd /root/
rm -rf /root/pyserial;

echo " "
echo "   ##############################"
echo "   ### Moonraker dependencies ###"
echo "   ##############################"
echo " "

echo "Installing moonraker dependencies..."
opkg install python3-zeroconf python3-yaml python3-pillow libsodium python3-dbus-fast;
pip install -r moonraker-requirements.txt;

echo " "
echo "   ###############"
echo "   ###  Nginx  ###"
echo "   ###############"
echo " "

echo "Installing nginx..."
opkg install nginx-ssl;

echo " "
echo "   ###############"
echo "   ### Klipper ###"
echo "   ###############"
echo " "

echo "Cloning Klipper..."
git clone --depth 1 https://github.com/Klipper3d/klipper.git /root/klipper;

echo "Creating klipper service..."
wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/Services/klipper -P /etc/init.d/;
chmod 755 /etc/init.d/klipper;
/etc/init.d/klipper enable;

mkdir -p /root/printer_data/config;

echo " "
echo "   #################"
echo "   ### Moonraker ###"
echo "   #################"
echo " "

git clone https://github.com/Arksine/moonraker.git /root/moonraker;
wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/Services/moonraker -P /etc/init.d/
chmod 755 /etc/init.d/moonraker
/etc/init.d/moonraker enable
wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/nginx/upstreams.conf -P /etc/nginx/conf.d/
wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/nginx/common_vars.conf -P /etc/nginx/conf.d/
/etc/init.d/nginx enable

echo " "
echo "   #################"
echo "   ###  Client   ###"
echo "   #################"
echo " "

choose(){
	echo " "
	echo "Choose prefered Klipper client:"
	echo "  1) Fluidd"
	echo "  2) Mainsail"
	echo "  3) Quit"
	echo " "
	while true; do
		read n
		case $n in
		1)
    	echo "You chose Fluidd"
		  echo "Installing Fluidd..."
		  echo " "
		  echo "   ***************************"
		  echo "   **     Downloading...    **"
		  echo "   ***************************"
		  echo " "
		  mkdir /root/fluidd;
		  wget -q -O /root/fluidd/fluidd.zip https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip && unzip /root/fluidd/fluidd.zip -d /root/fluidd/ && rm /root/fluidd/fluidd.zip;
		  wget -O /root/printer_data/config/moonraker.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/moonraker/fluidd_moonraker.conf;
		  wget -O /etc/nginx/conf.d/fluidd.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/nginx/fluidd.conf;
			wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/klipper_config/fluidd.cfg -P /root/printer_data/config/
	    echo "   ***************************"
			echo "   **         Done!         **"
			echo "   ***************************"
			echo " "
     	break
			;;
		2)
			echo "You chose Mainsail"
			echo "Installing Mainsail..."
			echo " "
			echo "   ***************************"
			echo "   **     Downloading...    **"
			echo "   ***************************"
			echo " "
			mkdir /root/mainsail;
			wget -q -O /root/mainsail/mainsail.zip https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip && unzip /root/mainsail/mainsail.zip -d /root/mainsail/ && rm /root/mainsail/mainsail.zip;
			wget -O /root/printer_data/config/moonraker.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/moonraker/mainsail_moonraker.conf;
			wget -O /etc/nginx/conf.d/mainsail.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/nginx/mainsail.conf;
			wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v4.1/klipper_config/mainsail.cfg -P /root/printer_data/config/
			echo "   ***************************"
			echo "   **         Done          **"
			echo "   ***************************"
			echo " "
     	break
			;;
		3)
		  echo "Quitting..."
     	exit
			;;
		*) echo "Choose a valid option!";;
		esac
  done
}

choose;

echo " "
echo "   #################"
echo "   ###  Webcam   ###"
echo "   #################"
echo " "

echo "Installing mjpg-streamer..."
opkg install v4l-utils kmod-video-uvc;
opkg install mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www ffmpeg;

rm /etc/config/mjpg-streamer;
cat << "EOF" > /etc/config/mjpg-streamer
config mjpg-streamer 'core'
        option enabled '0'
        option input 'uvc'
        option output 'http'
        option device '/dev/video0'
        option resolution '640x480'
        option yuv '0'
        option quality '80'
        option fps '5'
        option led 'auto'
        option www '/www/webcam'
        option port '8080'
        #option listen_ip '192.168.1.1'
        #option username 'openwrt'
        #option password 'openwrt'
EOF

/etc/init.d/mjpg-streamer enable;
ln -s /etc/init.d/mjpg-streamer /etc/init.d/webcamd;

echo " "
echo "   ###################"
echo "   ### Hostname/ip ###"
echo "   ###################"
echo " "

echo "Using hostname instead of ip..."
opkg install avahi-daemon-service-ssh avahi-daemon-service-http;

echo " "
echo "   #################"
echo "   ### Timelapse ###"
echo "   #################"
echo " "

opkg install wget-ssl;

echo "Installing Timelapse packages..."
git clone https://github.com/shivajiva101/moonraker-timelapse.git /root/moonraker-timelapse;
/root/moonraker-timelapse/install.sh;

echo " "
echo "   ########################"
echo "   ### tty hotplug rule ###"
echo "   ########################"
echo " "

echo "Install tty hotplug rule..."
opkg install usbutils;
cat << "EOF" > /etc/hotplug.d/usb/22-tty-symlink
# Description: Action executed on boot (bind) and with the system on the fly
PRODID="1a86/7523/264" #change here according to "PRODUCT=" from grep command
SYMLINK="ttyPrinter" #you can change this to whatever you want just don't use spaces. Use this inside printer.cfg as serial port path
if [ "${ACTION}" = "bind" ] ; then
  case "${PRODUCT}" in
    ${PRODID}) # mainboard product id prefix
      DEVICE_TTY="$(ls /sys/${DEVPATH}/tty*/tty/)"
      # Mainboard connected to USB1 slot
      if [ "${DEVICENAME}" = "1-1.4:1.0" ] ; then
        ln -s /dev/${DEVICE_TTY} /dev/${SYMLINK}
        logger -t hotplug "Symlink from /dev/${DEVICE_TTY} to /dev/${SYMLINK} created"

      # Mainboard connected to USB2 slot
      elif [ "${DEVICENAME}" = "1-1.2:1.0" ] ; then
        ln -s /dev/${DEVICE_TTY} /dev/${SYMLINK}
        logger -t hotplug "Symlink from /dev/${DEVICE_TTY} to /dev/${SYMLINK} created"
      fi
    ;;
  esac
fi
# Action to remove the symlinks
if [ "${ACTION}" = "remove" ]  ; then
  case "${PRODUCT}" in
    ${PRODID})  #mainboard product id prefix
     # Mainboard connected to USB1 slot
      if [ "${DEVICENAME}" = "1-1.4:1.0" ] ; then
        rm /dev/${SYMLINK}
        logger -t hotplug "Symlink /dev/${SYMLINK} removed"

      # Mainboard connected to USB2 slot
      elif [ "${DEVICENAME}" = "1-1.2:1.0" ] ; then
        rm /dev/${SYMLINK}
        logger -t hotplug "Symlink /dev/${SYMLINK} removed"
      fi
    ;;
  esac
fi
EOF

echo " "
echo "   ########################"
echo "   ###  Fixing logs...  ###"
echo "   ########################"
echo " "
echo "Creating system.log..."

uci set system.@system[0].log_file='/root/klipper_logs/system.log';
uci set system.@system[0].log_size='51200';
uci set system.@system[0].log_remote='0';
uci commit;

echo " "
echo "Installing logrotate..."
echo " "
opkg install logrotate;

echo " "
echo "Creating cron job..."
echo " "
echo "0 8 * * * *     /usr/sbin/logrotate /etc/logrotate.conf" >> /etc/crontabs/root


echo " "
echo "Creating logrotate configuration files..."
echo " "

cat << "EOF" > /etc/logrotate.d/klipper
/root/klipper_logs/klippy.log
{
    rotate 7
    daily
    maxsize 64M
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
}
EOF

cat << "EOF" > /etc/logrotate.d/moonraker
/root/klipper_logs/moonraker.log
{
    rotate 7
    daily
    maxsize 64M
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
}
EOF

echo " "
echo "   #################"
echo "   ###   Done!   ###"
echo "   #################"
echo " "

echo "Please reboot and wait a while for the changes to take effect.";
echo "You can then proceed to configuring a printer.cfg file!";
read -p "Press [ENTER] to reboot...or [ctrl+c] to exit"

reboot

else
echo "Please run the first script before this one!"
fi
