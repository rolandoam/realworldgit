#!/bin/sh

today=$(date +"%s")
hash=$(echo " - rwgit - " $RANDOM " " $today | shasum | awk '{print $1}')
echo $hash > ./auto/ping.txt
# pull changes
git pull
if [ $? == 0 ]; then
    msgdate=$(date +"%Y%m%d-%H:%M")
    git add auto/ping.txt
    git commit -m "ping sent at $msgdate"
    git push
fi

: <<EOF
This script is meant to be installed somewhere and run in a
cronjob. Ideally it would do something like this:

cd /path/to/repo && sh script.sh

This script can be executed every 10 minutes or so.

EOF