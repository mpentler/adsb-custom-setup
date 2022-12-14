# adsb-custom-setup
My own personal setup-from-scratch scripts and modifications to a basic headless RPi ADS-B decoder/feeder, with an added web dashboard featuring mobile compatibility (pull to refresh, dark/light mode).

The dashboard currently updates by default on the half hour - this can be changed in the stats.cron file before installation.

## Introduction
This script will download various pieces of software for running an ADS-B decoder and feeder. Choices are given at most, but not all stages, and some configuration files are also adjusted.

That last point is important: this WILL adjust system files and you should inspect the main adsb-install.sh before running it. There isn't much error-checking, if any.

It will also install a web frontend for accessing everything and viewing all of the stats and traffic to the port 80 lighttpd server.

<img src="https://i.imgur.com/wgOmN93.jpg" width="400">

## Installation
Clone the repo first to your /home/pi folder (change the script if your username is something different) and then:

Look at the scripts and edit anything else you want.

`sudo adsb-install.sh`

Follow the prompts as you go for choosing options and feeders. None of the scripts are very complex if you have a look at them, but as I made this for myself I'm not hugely interested in documenting things more than this right now, sorry!

Then access http://ipaddress/adsbdashboard to view the dashboard. I have no knowledge of how to make it work on https, sorry.

You will need to edit the URLs of the various stats pages to point to your account on each service. One day I may add configuration options for this but I've no real desire to, as it really is beyond my scripting skills.
