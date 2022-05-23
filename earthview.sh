#!/bin/bash

metadata=`curl -s https://earthview.withgoogle.com/_api/photos.json`

# get random slug
random_id=`expr $RANDOM % 2608`
slug=`echo $metadata | jq -r --arg i $random_id '.[$i | tonumber].slug'`

# get slug metadata
details=`curl -s https://earthview.withgoogle.com/_api/$slug.json`

# get path to 'current' dir
script="`realpath $0`"
current_dir="`dirname $script`/current"
mkdir -p $current_dir

# get details
url=`echo $details | jq -r .earthLink`
place=`echo $details | jq -r .name`
imageUrl=`echo $details | jq -r .photoUrl`
lat=`echo $details | jq -r .lat`
lon=`echo $details | jq -r .lng`

# generate urlfile
urlfile="$current_dir/earth.url"
echo [InternetShortcut] > $urlfile
echo url=$url >> $urlfile

# generate infofile
infofile="$current_dir/info.txt"
echo $place > $infofile
echo $lat, $lon >> $infofile

# find screen aspect ratio
bounds=`osascript -e 'tell application "Finder" to get bounds of window of desktop' | tr -d ","`
width=`echo $bounds | awk '{print $3}'`
height=`echo $bounds | awk '{print $4}'`

# get image
curl -s $imageUrl -o view.jpg --output-dir $current_dir

# crop image
magick convert "$current_dir/view.jpg" -gravity center -crop "$width:$height" "$current_dir/view.jpg"

# caption image
magick convert "$current_dir/view.jpg" \
    -font .SF-Compact \
    -undercolor "#00000060" \
    -fill "#ffffff" \
    -gravity southwest \
    -annotate +10+10 \
    "\ $place " "$current_dir/annotated.jpg"

# set image as wallpaper
osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$current_dir/annotated.jpg\""
killall Dock