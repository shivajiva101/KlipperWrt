# KlipperWrt
 ---------------------------------------------------------------------------------
 
 A guide to get _**Klipper**_ with _**fluidd**,_ _**Mainsail**_ or _**Duet-Web-Control**_ on OpenWrt embeded devices like the _Creality Wi-Fi Box_.
 
 **IMPORTANT: Switch to the tag of the version you want to install BEFORE downloading the firmware to ensure you are syncronised to the core packages, scripts and instructions!**

 ---------------------------------------------------------------------------------
### Before starting...

<details>
  <summary>Click to expand!</summary>
 
#### Why Klipper on a Router :question:

<details>
  <summary> ( :red_circle: Click to expand!)</summary>
 
 - OpenWrt is so much more efficient than other linux distros.   
 - On a single core 580MHz cpu (with moonraker, klippy, nginx and mjpg-streamer) I get ~20-25% cpu load while idle/not printing and max 35-40% cpu load while printing and watching stream (640x480 30fps mjpeg). 

![alt text](https://github.com/shivajiva101/KlipperWrt/blob/main/screenshots/top_idle_moonraker_klippy_nginx_mjpg_streamer.png)
![alt text](https://github.com/shivajiva101/KlipperWrt/blob/main/screenshots/htop_idle.png)
![alt text](https://github.com/shivajiva101/KlipperWrt/blob/main/screenshots/test_print.png)  
![alt text](https://github.com/shivajiva101/KlipperWrt/blob/main/screenshots/stream.png)  
![alt text](https://github.com/shivajiva101/KlipperWrt/blob/main/screenshots/test_print.jpg)
  * I've tried octoprint on this box as well but unfortunately it was too resource intensive. Test prints speak for themselves.

</details>

#### What is the Creality [Wi-Fi Box](https://www.creality.com/goods-detail/creality-box-3d-printer)?

<details>
  <summary>(Click to expand!)</summary>
 
[![creality_wb](img/creality_wb.jpg)](https://www.creality.com/goods-detail/creality-box-3d-printer)   
- A router box device released by Creality in 2020 meant to add cloud based remote control to your printer. Creality Cloud App is a contraption between social media and 3d printing that you have to use to be able to print and monitor.  
	
	Sounded like a good idea. Unfortunately, the unpolished idea was not very well received by the public. Creality recently (July 2021) added **Cura integration** and **custom gcode upload**. Webcam support finally got released but it seems to only work with their new **proprietary webcam**. Everything is still **cloud based** and you **can't use it offline**. This raised a lot of concerns in terms of privacy and transparency. Putting all your trust in a company is not necesarily the best idea and although they seemed to have improved the app and user experience the full control is not in the user's hands yet.  
	
	It's hard to please everybody when creating a product/service but actually listening to the public's feedback is a good start. People need privacy, full control and reliability to actually consider using the product over the alternatives. **Klipper** and it's UI clients come as **open source** and **100% transparent** alternatives to remote printing. 

 <details>
   <summary>Specifications (Click to expand!)</summary>
 
 *(taken form figgyc's commit)*

- **SoC**: MediaTek MT7688AN @ 580 MHz  
- **Flash**: BoyaMicro BY25Q128AS (16 MiB, SPI NOR)  
- **RAM**: 128 MiB DDR2 (Winbond W971GG6SB-25)  
- **Peripheral**: Genesys Logic GL850G 2 port USB 2.0 hub  
- **I/O**: 1x 10/100 Ethernet port, microSD SD-XC Class 10 slot, 4x LEDs, 2x USB 2.0 ports, micro USB input (for power only), reset button  
- **FCC ID**: 2AXH6CREALITY-BOX  
- **UART**: test pads: (square on silkscreen) 3V3, TX, RX, GND; default baudrate: 57600  
 
   </details>
 </details>

#### What is [OpenWrt](https://github.com/openwrt/openwrt)?

<details>
  <summary>(Click to expand!)</summary>
 
[![OpenWrt](img/OpenWrt.png)](https://openwrt.org)  

- A Linux OS built for embeded devices, routers especially. Light, Open Source  with a great community and <br> packages that gives your device the freedom it deserves.

 </details>
    
#### What is [Klipper](https://github.com/KevinOConnor/klipper)?

<details>
  <summary>(Click to expand!)</summary>
 
[![Klipper](img/klipper.png)](https://www.klipper3d.org/)  

- A 3d-printer firmware. It runs on any kind of computer taking advantage of the host cpu. Extremely light on cpu, lots of feautres
</details>

#### What is [fluidd](https://github.com/cadriel/fluidd) / [mainsail](https://github.com/meteyou/mainsail)?

<details>
  <summary>(Click to expand!)</summary>
 
[![fluidd](img/fluidd.png)](https://docs.fluidd.xyz)  [![mainsail](img/mainsail.png)](https://docs.mainsail.xyz)  
- These are free and open-source Klipper web interface clients for managing your 3d printer. 
</details>
 
#### What is [Moonraker](https://github.com/Arksine/moonraker)?

<details>
  <summary>(Click to expand!)</summary>
 
[![Moonraker](img/moonraker.png)](https://moonraker.readthedocs.io/en/latest/)  
- A Python 3 based web server that exposes APIs with which client applications (fluidd or mainsail) may use to interact with Klipper. Communcation between the Klippy host and Moonraker is done over a Unix Domain Socket. Tornado is used to provide Moonraker's server functionality.
</details>

#### What is [duet-web-control](https://github.com/Duet3D/DuetWebControl)


<details>
  <summary>(Click to expand!)</summary>
 
[![dwc](img/dwc.png)](https://duet3d.dozuki.com/Wiki/Duet_Web_Control_v2_and_v3_%28DWC%29_Manual)  
- Duet Web Control is a fully-responsive HTML5-based web interface for RepRapFirmware. [Stephan3](https://github.com/Stephan3/dwc2-for-klipper-socket) built a socket to make it communicate with klipper as well (klipper is not a RepRapFirmware). This is a standalone webserver and client interface - so no need for moonraker or nginx.
</details>

</details>

--------------------------------------------------------------------------

###  :clapper: Check out the latest [video](https://youtu.be/LCJYF-7xleM) tutorial by [Kruze17](https://github.com/Kruze17) on his [Hyper Makes](https://www.youtube.com/channel/UCrCxVyN2idCxPNOwCwK6qtQ) YouTube channel.

### :exclamation: Open issues or join the [<img align="center" width="30" height="30" src="https://github.com/shivajiva101/KlipperWrt/blob/main/img/discord.png" alt="discord_icon">](https://discord.gg/ZGrCMVs35H) [server](https://discord.gg/ZGrCMVs35H) for extra support.


--------------------------------------------------------------------------

# Automatic Steps:

<details>
  <summary>Click to expand!</summary>

### Installing Script method
Installs everything fresh and current. Possibly unstable if a new dependency is added to the applications stack before the script is updated.
<details>
  <summary>Click for STEPS!</summary>

This method uses 2 scripts to foramt an sd card and make it extroot and another one that installs everything from the internet.

#### STEPS:
 
- Make sure you've flahsed/sysupgraded latest `.bin` file from `/Firmware/OpenWrt_snapshot/` or from latest release.
- Connect to the `OpenWrt` access point
- Access LuCi web interface and log in on `192.168.1.1:81`
- _(**optional** but recommended)_ Add a password to the `OpenWrt` access point: `Wireless` -> Under wireless overview `EDIT` the `OpenWrt` interface -> `Wireless Security` -> Choose an encryption -> set a password -> `Save` -> `Save & Apply`
- _(**optional** but recommended)_ Add a password: `System` -> `Administration` -> `Router Password`
- ❗If your home network subnet is on 1 (192.168.1.x), in order to avoid any ip conflicts, change the static ip of the box LAN from 192.168.1.1 to something like 192.168.3.1. To do that access the luci webinterface -> `Network` -> `Interfaces` and edit the static ip -> `Save` -> press the down arow on the Save&Apply button -> `Apply Unchecked`. You can now access luci on the new ip and continue configureing Client setup. 
- Connect as a client to your Internet router: `Network` -> `Wireless` -> `SCAN` -> `Join Network` -> check `Lock to BSSID` -> `Create/Assign Firewall zone` then under `custom` type `wwan` enter -> `Submit` -> `Save` -> `Save & Apply`
- Connect back to your router and either find the new box's ip inside the `DHCP` list.
- ❗  Access the terminal tab (`Services` -> `Terminal`) ❗ If terminal tab is not working go to `Config` tab and change `Interface` to the interface you are connecting through the box (your wireless router SSID for example) -> `Save & Apply`.
- Download and execute the `1_format_extroot.sh` script:

>
    cd ~
    wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/scripts/1_format_extroot.sh
    chmod +x 1_format_extroot.sh
    ./1_format_extroot.sh

- You'll be prompted to reboot: type `reboot`

- Download and execute the `2_script_manual.sh` script:

>
    cd ~
    wget https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/scripts/2_script_manual.sh
    chmod +x 2_script_manual.sh
    ./2_script_manual.sh 2>&1 | tee install.log 
    
- Follow the prompted instructions and wait for everything to be installed
- remove the scripts when done: `rm -rf /root/*.sh`
- Done!

- When done and rebooted use `http://openwrt.local` or `http://box-ip`to access the Klipper client
- Done!


#### Setting up your `printer.cfg`
- put your `printer.cfg` inside `/root/klipper_config`
- delete these blocks from your `printer.cfg`: `[virtual_sdcard]`, `[display_status]`, `[pause_resume]` since they're included inside `fluidd.cfg`/ `mainsail.cfg`
- add these lines inside your `printer.cfg` depending on your klipper client (mainsail/fluidd):   
- **Fluidd:** 
`[include fluidd.cfg]` 
`[include timelapse.cfg]`

- **Mainsail:** 
`[include mainsail.cfg]` 
`[include timelapse.cfg]` 

- Under `[mcu]` block change your serial port path according to [this](https://github.com/ihrapsa/KlipperWrt/issues/8)[Optional]
- Build your `klippper.bin` mainboard firmware using a linux desktop/VM (follow `printer.cfg` header for instructions)
- Flash your mainboard according to the `printer.cfg` header
- Do a `FIRMWARE RESTART` inside fluidd/Mainsail
- Done
_____________________________________________
*Notes:*
-  If the box doesn't connect back to your router wirelessly connect to it with an ethernet cable and setup/troubleshoot wifi.
-  Check [here](https://github.com/mainsail-crew/moonraker-timelapse/blob/main/docs/configuration.md#slicer-setup) for how to set your `TIMELAPSE_TAKE_FRAME` macro inside your slicer layer change.

</details>
</details>
--------------------------------------------------------------------------

# Manual Steps:

<details>
  <summary>Click to expand!</summary>


### OpenWrt <img align="left" width="30" height="34" src="https://github.com/shivajiva101/KlipperWrt/blob/v3.4/img/OpenWrt.png" alt="openwrt_icon">

<details>
  <summary>Click for STEPS!</summary>

:exclamation: Although this is an OpenWrt snapshot (Device is not officially supported) it works seamlessly, as long as the core package feed points at the correct tag for the firmware version.
#### 1. Build OpenWrt image(optional)

<details>
  <summary>Click to expand!</summary>
 
* Only neccesary until the [port](https://github.com/openwrt/openwrt/pull/3802) gets merged and officially supported.
  * I recommend following figgyc's [post](https://github.com/figgyc/figgyc.github.io/blob/source/posts.org#compiling-openwrt-for-the-creality-wb-01-tips-and-tricks). You'll find there his experience and a guide to compile OpenWrt. Here is his OpenWrt [branch](https://github.com/figgyc/openwrt/tree/wb01) with support for the Creality Wi-Fi Box and the [PR](https://github.com/openwrt/openwrt/pull/3802) pending to merge to main OpenWrt.
  

  
  </details>
#### 2. Install OpenWrt to the device

<details>
  <summary>Click to expand!</summary>
 
Flashing:  
1) Rename factory.bin to cxsw_update.tar.bz2  
2) Copy it to the root of a FAT32 formatted microSD card.  
3) Turn on the device, wait for it to start, then insert the card. The stock firmware reads the install.sh script from this archive, the build script I added creates one that works in a similar way. Web firmware update didn't work in my testing.

</details>

#### 3. Setup Wi-Fi

<details>
  <summary>Click to expand!</summary>
 
* If the flashing was successful you should be able to ssh into the box through ethernet. Plug it in your PC (prefered way) or router and do `ssh root@192.168.1.1` in `Windows PowerShell` or any `unix terminal` or use `putty`.  
* Edit `/etc/config/network`, `/etc/config/wireless` and `/etc/config/firewall`. I've uploaded these to follow as a model (inside `Wi-Fi`).
* Use `iw dev wlan0 scan` to scan for near wi-fi networks and look for the bssid specific to your 2.4Ghz SSID.

</details>

#### 4. Enable [extroot](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration) _(to expand the storage on the TF card)_ and enable swap.

<details>
     <summary>Click to expand!</summary>
 

- **Extroot**
```
opkg update && opkg install block-mount kmod-fs-ext4 kmod-usb-storage kmod-usb-ohci kmod-usb-uhci e2fsprogs fdisk
DEVICE="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)"
uci -q delete fstab.rwm
uci set fstab.rwm="mount"
uci set fstab.rwm.device="${DEVICE}"
uci set fstab.rwm.target="/rwm"
uci commit fstab
mkfs.ext4 /dev/mmcblk0p1
DEVICE="/dev/mmcblk0p1"
eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*")
uci -q delete fstab.overlay
uci set fstab.overlay="mount"
uci set fstab.overlay.uuid="${UUID}"
uci set fstab.overlay.target="/overlay"
uci commit fstab
mount /dev/mmcblk0p1 /mnt
cp -f -a /overlay/. /mnt
umount /mnt
reboot

```

- **swap** (though the existing 128mb RAM seemed more than enough)

run this once:  

>
```
opkg update && opkg install swap-utils
dd if=/dev/zero of=/overlay/swap.page bs=1M count=512
mkswap /overlay/swap.page 
swapon /overlay/swap.page
mount -o remount,size=256M /tmp

```
update /etc/rc.local so that swap is enabled at boot:  

```
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

```

</details>

</details>


### fluidd <img align="left" width="30" height="30" src="https://github.com/shivajiva101/KlipperWrt/blob/v3.4/img/fluidd.png" alt="fluidd_icon"> / <img width="30" height="30" src="https://github.com/shivajiva101/KlipperWrt/blob/v3.4/img/mainsail.png" alt="mainsail_icon"> Mainsail

<details>
  <summary>Click for STEPS!</summary>
 
#### 5. Install dependencies

<details>
  <summary>Click to expand!</summary>
 
* for Klipper and moonraker - check the `requirements` folder. 
* Install`git-http` with `opkg update && opkg install git-http gcc unzip htop`
	
</details>
	
 >
    opkg install python3 python3-pip python3-cffi python3-dev python3-greenlet python3-jinja2 python3-markupsafe python3-msgpack;
    pip install --upgrade pip;
    pip install --upgrade setuptools;
    pip install python-can configparser;
    opkg install python3-tornado python3-pillow python3-distro python3-curl python3-zeroconf python3-paho-mqtt python3-yaml python3-requests ip-full libsodium;
    pip install pyserial-asyncio lmdb streaming-form-data inotify-simple libnacl preprocess-cancellation apprise ldap3 dbus-next importlib-metadata;

* Install nginx with `opkg install nginx-ssl`


</details>

#### 6. Install Klipper

<details>
  <summary>Click to expand!</summary>
 
- **6.1 Clone Klipper inside** `~/`  
           - `git clone --depth 1 https://github.com/Klipper3D/klipper.git`. 
- **6.2 Use provided klipper service and place inside `/etc/init.d/`**
	
>
	wget -q -O /etc/init.d/klipper https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/Services/klipper
	chmod 755 /etc/init.d/klipper

- **6.3 Enable klipper service:** 
	
>
	/etc/init.d/klipper enable
	
- **6.4 Prepare your `printer.cfg` file:**
	
>	
	mkdir ~/klipper_config ~/klipper_logs ~/gcode_files
	
	
- Locate your `.cfg` file inside `~/klipper/config/` copy it to `~/klipper_config` and rename it to `printer.cfg`
	
- Inside `printer.cfg` under `[mcu]` replace  serial line with `serial: /dev/ttyUSB0`

- Add either `[include mainsail.cfg]` or `[include fluidd.cfg]` to the top of the `printer.cfg` file depending on which front end you chose
           
- **6.5 Restart klipper** - do `service klipper restart` or `/etc/init.d/klipper restart`
- **6.6 Build `klipper.bin` file**  
            - Building is not mandatory to be done on the device that hosts klippy. To build it on this box you would need a lot of dependencies that are not available for OpenWrt so I just used my pc running ubuntu: On a different computer running linux (or VM or live USB) -> Clone klipper just like you did before -> `cd klipper` -> `make menuconfig` -> use the configurations specific to your mainboard (Check the header inside your `printer.cfg` file for details).  
:exclamation: use custom baud: `230400`. By default 250000 is selected. If you want/need that baud, remove the `python-pyserial` package and install this version of [pyserial](https://github.com/pyserial/pyserial) instead - check `Requirements` directory for details about installation process.
-> once configured run `make` -> if succesfull the firmware will be inside `./out/klipper.bin` -> flash the mainboard:(check header of `printer.cfg` again - some mainboards need the `.bin` file renamed a certain way) copy the `.bin` file on a sd card -> plug the card with the printer off -> turn printer on and wait a minute -> Done (Depending on your mainboard/printer/lcd you will probably not have a sign that the mainboard got flashed so don't worry) - if at the end of this guide the client cannot connect to the klipper firmware usually the problem is with the `.bin` file building or flashing process.
</details> 
 
#### 7. Install moonraker + fluidd/mainsail
<details>
  <summary>Click to expand!</summary>
 
- **7.1 Clone Moonraker** 
>
    cd ~
    git clone https://github.com/Arksine/moonraker.git

- **7.2 Use provided moonraker.conf file and download chosen client**   
	
**For fluidd:**

>
	mkdir ~/fluidd
	wget -q -O /root/fluidd/fluidd.zip https://github.com/fluidd-core/fluidd/releases/latest/download/fluidd.zip && unzip /root/fluidd/fluidd.zip -d /root/fluidd/ && rm /root/fluidd/fluidd.zip
	wget -q -O /root/klipper_config/moonraker.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/moonraker/fluidd_moonraker.conf
	wget -q -O /etc/nginx/conf.d/fluidd.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/nginx/fluidd.conf
	

**For Mainsail:**

>
	mkdir ~/mainsail
	wget -q -O /root/mainsail/mainsail.zip https://github.com/meteyou/mainsail/releases/latest/download/mainsail.zip && unzip /root/mainsail/mainsail.zip -d /root/mainsail/ && rm /root/mainsail/mainsail.zip
	wget -q -O /root/klipper_config/moonraker.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/moonraker/mainsail_moonraker.conf
	wget -q -O /etc/nginx/conf.d/mainsail.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/nginx/mainsail.conf
	
Note: _The `[update_manager]` plugin was commented out since this is curently only supported for `debian` distros only. For now, updating `moonraker`, `klipper`, `fluidd` or `mainsail` should be done manaully._  
	
Don't forget to edit(if necessary) the `moonraker.conf` file you copied inside `~/klipper_config` under `trusted_clients:` with your client ip or ip range (_client meaning the device you want to access fluidd/mainsail from_). Check the moonraker [configuration](https://github.com/Arksine/moonraker/blob/master/docs/configuration.md#authorization) doc for details.
- **7.3 Use provided moonraker service and place inside `/etc/init.d/`**

>
	wget -q -O /etc/init.d/moonraker https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/Services/moonraker
	chmod 755 /etc/init.d/moonraker
	/etc/init.d/moonraker enable
	/etc/init.d/moonraker restart
	
- **7.4 Download the rest of the nginx files inside `/etc/nginx/conf.d`***  
 
>
	wget -q -O /etc/nginx/conf.d/upstreams.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/nginx/upstreams.conf
	wget -q -O /etc/nginx/conf.d/common_vars.conf https://raw.githubusercontent.com/shivajiva101/KlipperWrt/v3.4/nginx/common_vars.conf
	
 Inside `/etc/nginx/conf.d` you should have `fluidd.conf` OR `mainsail.conf` alongside `common_vars.conf` AND `upstreams.conf` (those 2 files are common for mainsail and fluidd)

**Note!**  
You need to use either `fluidd.conf` or `mainsail.conf` file depending on your chosen client. Don't use both `.conf` files inside `/etc/nginx/conf.d/`. If you want to test both clients and easly switch between them check the **! How to switch between fluidd and mainsail:** below.


**Note!**  
It's ok to keep both client directories inside `/root/` as these are static files. Careful with the `.conf` file inside `/etc/nginx/conf.d`.
	
- **7.6 Restart nginx** with `service nginx restart` and check browser if `http://your-ip` brings you the client interface (fluidd or mainsail).

:exclamation: **How to switch between fluidd and mainsail:**
   1. switch between `mainsail.conf`and `fluidd.conf` file inside `/etc/nginx/conf.d` (make sure the other one gets renamed to a different `extension`. eg: `*.conf_off` or moved to a different folder.)
   2. Switch between mainsail and fluidd `moonraker.conf` files inside `~/klipper_config`. Find them inside my repo under `moonraker` directory.
   3. Restart moonraker and nginx services: `service moonraker restart` and `service nginx restart`
</details>
 
 
#### 8. Install mjpg-streamer - for webcam stream

<details>
  <summary>Click to expand!</summary>
 
* install video4linux utilities: `opkg update && opkg install v4l-utils`
* use commands: `opkg update && opkg install mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www`
* connect a uvc webcam, configure `/etc/config/mjpg-streamer` to your likings, enable and restart service: 
>`/etc/init.d/mjpg-streamer enable`  
`/etc/init.d/mjpg-streamer restart`
* put the stream link inside the client(fluidd/mainsail) camera setting: `http://<your_ip>/webcam/?action=stream`

</details>
 
 #### 9. (Optional) Use hostname instead of ip

<details>
  <summary>Click to expand!</summary>
 
* To change your hostname go to `/etc/config/system` and modify `option hostname 'OpenWrt'` to your likings.
* To use your hostname in browser and ssh instead of the ip do:
> 

    opkg update
    opkg install avahi-daemon-service-ssh avahi-daemon-service-http
    reboot
* Instead of `http://your-ip` use `http://your_hostname.local`
</details>
 
#### 10. Enjoy

</details>


### duet-web-control <img align="left" width="30" height="30" src="https://github.com/shivajiva101/KlipperWrt/blob/main/img/dwc.png" alt="dwc_icon"> 

<details>
  <summary>Click for STEPS!</summary>

#### 5. Install dependencies

<details>
  <summary>Click to expand!</summary>
 
* for Klipper - check the `requirements.txt` file. 


 </details>

#### 6. Install Klipper

<details>
  <summary>Click to expand!</summary>
 
- **6.1 Clone Klipper inside** `~/`  
           - do `opkg install git-http unzip` then  `git clone --depth 1 https://github.com/KevinOConnor/klipper.git`. 
- **6.2 Use provided klipper service and place inside `/etc/init.d/`**  - find it inside `Services -> klipper`
- **6.3 Enable klipper service:** Everytime you create a service file you need to give it executable permissions before enabling it. For klipper do `chmod 755 klipper`. You can enable it now by `/etc/init.d/klipper enable`
- **6.4 Prepare your `printer.cfg` file**
           - do `mkdir ~/klipper_config`  and  `mkdir ~/gcode_files` . Locate your `.cfg` file inside `~/klipper/config/` copy it to `~/klipper_config` and rename it to `printer.cfg`
           - Inside `printer.cfg` under `[mcu]` replace  serial line with `serial: /dev/ttyUSB0` and add a new line: `baud: 230400` - (check requirements if you want/need 250000 baud)  
- **6.5 Restart klipper** - do `service klipper restart` or `/etc/init.d/klipper restart`
- **6.6 Build `klipper.bin` file**
            - Building is not mandatory to be done on the device that hosts klippy. To build it on this box you would need a lot of dependencies that are not available for OpenWrt so I just used my pc running ubuntu: On a different computer running linux (or VM or live USB) -> Clone klipper just like you did before -> `cd klipper` -> `make menuconfig` -> use the configurations specific to your mainboard (Check the header inside your `printer.cfg` file for details).  
:exclamation: use custom baud: `230400`. By default 250000 is selected. If you want/need that baud, remove the `python-pyserial` package and install this version of [pyserial](https://github.com/pyserial/pyserial.git) instead - check `Requirements` directory for details about installation process.
-> once configured run `make` -> if succesfull the firmware will be inside `./out/klipper.bin` -> flash the mainboard:(check header of `printer.cfg` again - some mainboards need the `.bin` file renamed a certain way) copy the `.bin` file on a sd card -> plug the card with the printer off -> turn printer on and wait a minute -> Done (Depending on your mainboard/printer/lcd you will probably not have a sign that the mainboard got flashed so don't worry) - if at the end of this guide the client cannot connect to the klipper firmware usually the problem is with the `.bin` file building or flashing process.

</details>

#### 7. Get dwc socket for klipper

<details>
  <summary>Click to expand!</summary>

* **Download**  
`cd ~`  
`git clone https://github.com/Stephan3/dwc2-for-klipper-socket`  

* **Edit `dwc2.cfg`** - set the `web_root:` path to absolute path: `/root/sdcard/web`

* **Create dwc socket service**  
Create a `dwc` file inside `/etc/init.d/` with the contents of the `dwc` file inside my repo: `Services->dwc`  
Give it executable permissions: `chmod 755 /etc/init.s/dwc`  
Enable it: `/etc/init.d/dwc enable`  

</details>

#### 8. Get dwc

<details>
  <summary>Click to expand!</summary>
 
 * Download dwc version 3 web interface  

>

    mkdir -p ~/sdcard/web
    cd ~/sdcard/web
    wget -O DuetWebControl-SD.zip https://github.com/Duet3D/DuetWebControl/releases/download/3.1.1/DuetWebControl-SD.zip
    unzip *.zip && for f_ in $(find . | grep '.gz');do gunzip ${f_};done
    rm DuetWebControl-SD.zip

 
 * Restart dwc socket service: `service dwc restart` or `/etc/init.d/dwc restart`  
 * Test: `https:://<your_ip>:4750`
 
</details>

#### 9. (Optional) Use hostname instead of ip

<details>
  <summary>Click to expand!</summary>
 
* To change your hostname go to `/etc/config/system` and modify `option hostname 'OpenWrt'` to your likings.
* To use your hostname in browser and ssh instead of the ip do:
> 

    opkg update
    opkg install avahi-daemon-service-ssh avahi-daemon-service-http
    reboot
* Instead of `http://your-ip` use `http://your_hostname.local`
</details>

#### 10. Enjoy

</details>

</details>

--------------------------------------------------------------------------

### Flashing a new OpenWrt .bin file 
(aka Sysupgrading)	

<details>
  <summary>Click to expand!</summary>
	
1. Downloadthe sysupgrade.bin file to your computer  
2. Connect the box to your pc and make sure it's reachable by ssh	
3. Transfer it to the box inside `/tmp` directory with WinSCP or through command in Powershell/UNIX Terminal: `scp /path/to/sysupgrade.bin root@192.168.1.1:/tmp` 
4. ssh to the box and navigate to `/tmp` make sure the bin is there  
5. Do `sysupgrade -n -v *bin`  

</details>	

--------------------------------------------------------------------------
	
#### Troubleshooting

<details>
  <summary>Click to expand!</summary>

* Open a separate `ssh` instance and run `logread -f` - you'll get real time log data of the running process.  
* You can always open an issue or contact me if you get stuck or something doesn't work.  

</details>

--------------------------------------------------------------------------
#### :computer: Useful commands

<details>
  <summary>Click to expand!</summary>
 
 - Creating a non-privileged user  
  Check this [guide](https://openwrt.org/docs/guide-user/security/secure.access#create_a_non-privileged_user_in_openwrt)
     *All the tests I did were as root* - some modifications would be necessary to not run everything as root.  
    - Packages needed: `shadow-useradd` , `sudo`, `shadow-groupadd`, `shadow-usermod`

- Copy files to the box 
`scp /path/file.ext root@<your_box_ip>:/tmp`  

- Watch realtime CommandLine log (open an aditional terminal instance for this)  
`logread -f`  

- Services commands (Replace `service` with `klipper`/`moonraker`/`nginx`/`mjpg-streamer` respectively)  
`/etc/init.d/service enable`  
`/etc/init.d/service start`  
`/etc/init.d/service restart`  

- Check CPU/system resources usage  
`top`

- Check webcam specifcations  
`v4l2-ctl --all`  
`v4l2-ctl --list-formats`  

- List installed packages  
`opkg list-installed`

- Reboot, Poweroff  
`reboot`  
`poweroff`

</details>

--------------------------------------------------------------------------

#### :exclamation: Issues I had but solved:

<details>
  <summary>Click to expand!</summary>
 
- If enabling the services returns an error, do: `ls -l` inside `/etc/init.d/` and check if the service has executable permissions (x flag). If not do: `chmod 755 service` - replace `service` accordingly.

- I didn't manage to get the printer to communicate on 250000 baudrate (Official version of pyserial is unable to set a custom nonstandard baudrate - I found the fix by [ckielstra](https://github.com/pyserial/pyserial/pull/496) has been merged but isn't currently being used by pip. Use [forked](https://github.com/pyserial/pyserial) pyserial as well which is updated more often. If you don't want to use 250k baudrate you can solve this issue by using 230400 instead (you need to change this both while building the mcu klipper firmware AND inside printer.cfg under [mcu]:
`[mcu]`  
`baud: 230400`  

- The Host and Services commands (`Reboot`, `Shutdown`, `Restart Moonraker`, `Restart Klipper` etc.) inside fluidd/mainsail did not work at first due to moonraker using debian syntax. I solved this by editing the `~moonraker/moonraker/components/machine.py`. Use these commands inside `self._execute_cmd("command")`: `"poweroff"`, `"reboot"`, `f'/etc/init.d/{service_name} restart'` for host *poweroff*, *reboot* and *services restart* respectively.

</details>

--------------------------------------------------------------------------	
### :warning: Recovering/Unbricking OpenWrt

<details>
  <summary>Click to expand!</summary>

1. Download a previowsly working SYSUPGRADE OpenWrt image.
2. Rename it to `root_uImage`
3. Put it on a FAT32 formatted USB stick (NOT sd card)
4. Insert it in the box while off
5. Press and hold the reset button
6. Power on the box while still holding the reset button for about 6-10 sec.
7. Release the button and wait for a couple of minutes. After a couple of seconds you should find the KlipperWrt AP. You should be able to ssh into it through ethernet or connected to it's wifi (`ssh root@192.168.1.1`) 

</details>

### :warning:  Going back to stock (if ever needed) :

<details>
  <summary>Click to expand!</summary>
 
1. Download a [stock](http://file2-cdn.creality.com/model/cfg/box/V1.01b51/cxsw_update.tar.bz2) image (found inside `Firmware/Creality_Stock` folder as well) 
2. Unzip the stock `tar.bz2` and get the `root_uImage` file
3. Put it on a FAT32 formatted USB stick (NOT sd card)
4. Insert it in the box while off
5. Press and hold the reset button
6. Power on the box while still holding the reset button for about 6-10 sec.
7. Release the button and wait for a couple of minutes. After a few seconds you should find it on network.

</details>

--------------------------------------------------------------------------
### Credits:
* the idea: Hackaday.com - for the [article](https://hackaday.com/2020/12/28/teardown-creality-wifi-box) that set me on this journey
* the hard part: figgyc - for porting [OpenWrt](https://github.com/figgyc/openwrt/tree/wb01) to the Creality Wi-Fi Box
* the essentials: 
  - Kevin O'Connor - for [Klipper](https://github.com/KevinOConnor/klipper)
  - cadriel - for [fluidd](https://github.com/cadriel/fluidd)
  - mateyou - for [mainsail](https://github.com/meteyou/mainsail)  
  - Eric Callahan - for [Moonraker](https://github.com/Arksine/moonraker)
  - Stephan3 - for [dwc socket](https://github.com/Stephan3/dwc2-for-klipper-socket)
  - Duet3D - for [DuetWebControl](https://github.com/Duet3D/DuetWebControl)
* the fine tuning: andryblack - for the OpenWrt Klipper [service](https://github.com/andryblack/openwrt-build/tree/master/packages/klipper/files)
* the encouragement: [Tom Hensel](https://github.com/gretel)- for supporting Ihrapsa into creating this
--------------------------------------------------------------------------

