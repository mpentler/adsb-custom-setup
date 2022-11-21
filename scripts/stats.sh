#!/bin/bash
sed -i "/Uptime:/{n;s/.*/$(uptime)/}"  /var/www/html/adsbdashboard/index.html
/usr/bin/echo "***SYSTEM STATS***" >> /tmp/output.ansi
/usr/sbin/iwconfig wlan0 | /usr/bin/grep Quality >> /tmp/output.ansi
/bin/bash /home/pi/throttled.sh >> /tmp/output.ansi
/usr/bin/ansilove -q -c 50 -o /var/www/html/adsbdashboard/stats.png /tmp/output.ansi
/usr/bin/rm -rf /tmp/output.ansi
