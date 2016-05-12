#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please enter location and filename"
    exit
fi

scp -P 2222 main.xm "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp -P 2222 enableTextReply.xm "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp -P 2222 log.xm "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp -P 2222 Makefile "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp -P 2222 control "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
scp -P 2222 pebblesmstweak.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/"
# scp pebblesmstweak/Makefile "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
# scp pebblesmstweak/entry.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
# scp pebblesmstweak/pebblesmstweak.mm "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
# scp pebblesmstweak/Resources/Info.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
# scp pebblesmstweak/Resources/pebblesmstweak.plist "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
# scp pebblesmstweak/pebblesmstweak.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak"
# scp pebblesmstweak/Resources/pebblesmstweak.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
# scp pebblesmstweak/Resources/pebblesmstweak@2x.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"
# scp pebblesmstweak/Resources/pebblesmstweak@3x.png "root@$1:/var/mobile/Documents/pebble-text/pebblesmstweak/pebblesmstweak/Resources"