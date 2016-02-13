#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please enter location and filename"
    exit
fi

scp Tweak.xm "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp control "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp pebblesmstweak.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp Makefile "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"