# adsb-custom-setup
My own personal setup scripts and modifications to a basic RPi ADS-B decoder/feeder, with an added web dashboard featuring with mobile compatibility (pull to refresh, dark/light mode).

The dashboard currently updated by default on the half hour - this can be changed in the stats.cron file before installation.

## Introduction
This script will download various pieces of software for running an ADS-B decoder and feeder. Choices are given at most, but not all stages, and some configuration files are also adjusted.

That last point is important: this WILL adjust system files and you should inspect the main adsb-install.sh before running it.

It will also install a web frontend for accessing everything and viewing all of the stats and traffic to the port 80 lighttpd server.
![App Screenshot](https://i.imgur.com/wgOmN93.jpg "App Screenshot")

## Installation
Clone the repo first to your /home/pi folder (change the script if your username is something different) and then:

Look at the scripts and edit anything else you want.

`sudo adsb-install.sh`

Follow the prompts as you go for choosing options and feeders. None of the scripts are very complex if you have a look at them, but as I made this for myself I'm not hugely interested in documenting things more than this right now, sorry!
