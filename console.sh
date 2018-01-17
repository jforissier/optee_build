#!/bin/bash
#
# miniterm.py is in Ubuntu package python-serial
# $ sudo apt-get install python-serial
#
# Adjust USB device as needed

DEV=${1:-/dev/ttyUSB0}
miniterm.py --raw --eol CR ${DEV} 115200
