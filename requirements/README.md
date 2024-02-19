
### Klipper dependencies:
------------------------

* Python3 - install with `opkg install python3 --force-overwrite`
* Python3-pip - install with `opkg install python3-pip`
* Python3 packages:  
  | package | instructions |
  |-|-|
  | cffi==1.14.6 | install with `opkg install python-cffi`|
  | pyserial==3.4 | install with `opkg install python-pyserial`. :exclamation: This pyserial version currently works with a max baud of 230400. If you'd like 250000 Install this pyserial [version](https://github.com/pyserial/pyserial) using `python3 setup.py install` |
  | greenlet==2.0.2 | To build and install it on the box you need `gcc` and `python-dev`.|
  | Jinja2==2.11.3 | Install with `opkg install python3-jinja2`|
  | python-can==3.3.4 | Install with `pip install python-can`|
  | markupsafe==1.1.1 | Install with `opkg install python3-markupsafe`|

### Moonraker dependencies:
------------------------

* Python3 packages:  
  | package | instructions |
  |-|-|
  | pyserial==3.4 | install with `opkg install python3-pyserial --force-overwrite`|
  | pillow==8.0.1 | install with `opkg install python3-pillow`|
  | tornado==6.1.0 | install with `opkg install python3-tornado`|
  | distro==1.5.0 | install with `opkg install python3-distro`|
  | inotify-simple==1.3.5 | install with `pip install inotify-simple` - if you get a `_distutils_hack` error update python3-setuptools to ver>=56.2. OpenWrt repo might not have the latest version so you'd probably have to download it from [github](https://github.com/pypa/setuptools) and manually install it: Clone setuptools [repo](https://github.com/pypa/setuptools.git) `cd` to root fodler then `python3 setup.py install`|
  | lmdb==1.1.1 | I had issues with it - I provided a cross-compiled package inside [`Packages`](https://github.com/ihrapsa/KlipperWrt/tree/main/packages). If you don't manage to install it or moonraker still errors on it switch to an [older](https://github.com/Arksine/moonraker/archive/eb37ce767d73b064b0260432e4a3323cf8e8d758.zip) release of moonraker where this package is not a requirement |
  | streaming-form-data==1.8.1 | I had issues with it - I provided a cross-compiled package inside [`Packages`](https://github.com/ihrapsa/KlipperWrt/tree/main/packages) |
  | python-jose[cryptography]==3.2.0 |  Install with `pip install python-jose` - if you get errors with this install it manually: Clone the python-jose [repo](https://github.com/mpdavis/python-jose.git) `cd` into it then `python3 setup.py install` | 
  | libnacl==1.7.2 |  Install with `pip install libnacl` |  
  | paho-mqtt==1.5.1 |  Install with `pip install paho-mqtt==1.5.1` |  
  | pycurl==7.44.1 |  Install with `opkg install python3-curl` |
  | libcurl4 | Install with `opkg install libcurl4` |
  | zeroconf==0.37.0 | Install with `pip3 install zeroconf` |
  | preprocess-cancellation==0.1.6 | Install with `pip install preprocess-cancellation` |
  | jinja2=3.0.3 | Install with `pip install jinja2`|
  | dbus-next==0.2.3 | Install with `pip install dbus-next`|

* libsodium - install with `opkg install libsodium`  
* nginx - install with `opkg install nginx-ssl`
### Duet-Web-Control dependencies:
------------------------

* Python3 packages:
  | package | instructions |
  |-|-|
  | tornado==6.1.0 | install with `opkg install python3-tornado`|

___________________________

* If you can't install python3 packages with opkg or pip and can't find them inside menuconfig either you can build them by selecting `[*] Advanced configuration options (for developers)`. After that a _`python3-packages`_ option will appear inside _`Languages`_ --> `Python` --> `python3-packages` -> select it with `<M>` -> type pacakge names space delimited inside --> `() List of python3 pacakges to install on target` 
* `lmdb` and `streaming-form-data` were cross-compiled that way. A single `*ipk` file installs both python packages.
