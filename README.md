# adsb-custom-setup
My own personal setup scripts and modifications to a basic RPi ADS-B decoder/feeder

## Introduction

This script will download various pieces of software for running an ADS-B decoder and feeder. Choices are given at most, but not all stages, and some configuration files are also adjusted.

That last point is important: this WILL adjust system files and you should inspect the main adsb-install.sh before running it.

It will also install a web frontend for accessing everything and viewing all of the stats and traffic to the port 80 lighttpd server.
