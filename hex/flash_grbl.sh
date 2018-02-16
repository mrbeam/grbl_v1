#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No file to flash provided."
    exit 0
fi

if [ ! -f "$1" ]; then
    echo "File $1 not found"
    exit 1
fi

echo ""
echo "Flashing file: $1"
echo ""
echo "Make sure your device is plugged in."
echo "Then press enter to continue"
echo ""
read -p ""


avrdude -c avrispmkII -p atmega328p -U "flash:w:$1:i" -U efuse:w:0xfc:m -U hfuse:w:0xde:m -U lfuse:w:0xff:m -U lock:w:0xcf:m