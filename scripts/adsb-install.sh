#!/bin/bash
#ADS-B Feeder install script - run this after RPi first boot
#ToDo: How to determine latest version of some feeder URLs before downloading - they are referenced by specific version number right now

echo "*** Completing headless Raspbian setup tasks (settings config and software removal..."

#disable HDMI output
while true; do
  read -p "Disable HDMI in /etc/rc.local? (y/n): " yn
  case $yn in
    [yY]* ) sed -i '$i \/usr/bin/tvservice -o\n' /etc/rc.local; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#change CPU governor to ondemand (can disable raspi-config.service after this, as it sets performance mode)
#does this need to be a user choice?
echo "Setting CPU governor to ondemand mode on boot"
sed -i '$i \echo "ondemand" | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor' /etc/rc.local

#disable and uninstall Bluetooth software
read -p "Disable and uninstall Bluetooth software? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) systemctl disable hciuart.service
    systemctl disable bluealsa.service
    systemctl disable bluetooth.service
    apt-get purge bluez -y
    apt-get autoremove -y ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#disable other unneeded services
echo "Disabling some other unneeded services..."
systemctl disable avahi-daemon.service
systemctl disable avahi-daemon.socket
systemctl disable ModemManager.service
systemctl disable triggerhappy.service
systemctl disable triggerhappy.socket
systemctl disable raspi-config.service

#switch sshd to on-demand setup
echo "Switching to on-demand SSH daemon rather than always-on..."
systemctl disable ssh.service
systemctl enable ssh.socket

#make changes to /boot/config.txt to enable, disable, or edit certain options - can this be done in a better way?
echo -e "enable_uart=0\ngpu_mem=16\nenable_tvout=0" >> /boot/config.txt

#gather some information to be used later (but not yet!)
read -p "What is the decimal X longitude coordinate of the antenna (to 4 decimal places)? :" loncoord
read -p "What is the decimal Y latidude coordinate of the antenna (to 4 decimal places)? :" latcoord
read -p "How high is the antenna above the ground in metres?: " antalt

#install dump1090-fa, tar1090, and graphs1090 from wiedehopf's excellent scripts
echo "*** Installing dump1090-fa, graphs1090 and tar1090...\n"

echo "Firstly, dump1090-fa"
bash -c "$(curl -L -o - https://github.com/wiedehopf/adsb-scripts/raw/master/install-dump1090-fa.sh)"

echo "Secondly, tar1090"
bash -c "$(curl -L -o - https://github.com/wiedehopf/tar1090/raw/master/install.sh)"

echo "Lastly, graphs1090"
bash -c "$(curl -L -o - https://github.com/wiedehopf/graphs1090/raw/master/install.sh)"

#install feeders - most of this is interactive unfortunately
echo "*** Installing feeder software...\n"

#ADSB Exchange
read -p "Install ADSB Exchange? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) bash -c "$(curl -L -o - https://adsbexchange.com/feed.sh)" ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#FlightRadar24 (need to somehow disable MLAT!)
read -p "Install FlightRadar 24? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) bash -c "$(curl -L -o - https://repo-feed.flightradar24.com/install_fr24_rpi.sh)" ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#FlightAware - this URL needs editing manually per version number
read -p "Install PiAware? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) curl -L -O https://uk.flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_7.2_all.deb
    dpkg -i piaware-repository_7.2_all.deb
    apt-get update
    apt-get install piaware -y
    piaware-config allow-auto-updates yes
    piaware-config allow-manual-updates yes ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#Plane Finder - this URL needs editing manually per version number
read -p "Install Plane Finder? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) curl -L -O http://client.planefinder.net/pfclient_5.0.161_armhf.deb
    dpkg -i pfclient_5.0.161_armhf.deb ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#OpenSky Network
read -p "Install OpenSky Network? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) curl -L -O https://opensky-network.org/files/firmware/opensky-feeder_latest_armhf.deb
    dpkg -i opensky-feeder_latest_armhf.deb ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

#RadarBox
read -p "Install RadarBox? (y/n): " yn
while true; do
  case $yn in
    [yY]* ) bash -c "$(curl -L -o - http://apt.rb24.com/inst_rbfeeder.sh)" ; break ;;
    [nN]* ) echo "skipping..." ; break ;;
    *) echo 'Invalid input' >&2 ;;
  esac
done

echo "*** All feeders complete - remember to configure them all separately if required!\n"

echo "*** Configuring some app-specific settings...\n"

#change dump1090-fa settings (gain etc)
read -p "Select SLOW_CPU setting (yes/no/auto): " slowcpu
sed -i "s/SLOW_CPU=auto/SLOW_CPU=$slowcpu/" /etc/default/dump1090-fa

#change tar1090 settings (customise view)
read -p "How long a tar1090 ptracks history would you like (in hours)?: " ptrackshrs
sed -i "s/PTRACKS=8/PTRACKS=$ptrackshrs/" /etc/default/tar1090

#prompt user for some graphs1090 settings
read -p "How long would you like between graphs1090 redraws (in seconds)?: " drawinterval
sed -i "s/DRAW_INTERVAL=60/DRAW_INTERVAL=$drawinterval/" /etc/default/graphs1090

#make webpage - perhaps download from my gists?
read -p "Installing web dashboard at http://localhost/dashboard/ ?: " yn
cp -R dashboard/ /var/www/html/
cp scripts/*.sh
#add cronjob here

#fully update system to finish
echo "*** Running one last full system update...\n"
apt-get upgrade -y
apt-get dist-upgrade -y

echo "*** Finished! You should now reboot the system...\n"
exit 0
