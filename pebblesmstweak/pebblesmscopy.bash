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
scp pebblesmstweak/Makefile "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
scp pebblesmstweak/entry.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
scp pebblesmstweak/pebblesmstweak.mm "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
scp pebblesmstweak/Resources/Info.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
scp pebblesmstweak/Resources/pebblesmstweak.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
scp pebblesmstweak/pebblesmstweak.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
scp pebblesmstweak/Resources/pebblesmstweak.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
scp pebblesmstweak/Resources/pebblesmstweak@2x.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
scp pebblesmstweak/Resources/pebblesmstweak@3x.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"