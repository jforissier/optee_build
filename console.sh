#!/bin/bash
#
# miniterm is in Ubuntu 18.04 package python3-serial
# $ sudo apt install python3-serial
#
# Adjust USB device as needed

DEV=${1:-/dev/ttyUSB0}
miniterm --raw --eol CR ${DEV} 115200
