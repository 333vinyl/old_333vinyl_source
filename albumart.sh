#!/bin/bash -e
# get_coverart.sh
#
# This simple script will fetch the cover art for the album information provided on the command line.
# It will then download that cover image, and place it into the child directory.
# The term "album information" is really the relative path of the final directory.
#
# get_coverart <relative-path>
#
# get_coverart Tonic/Lemon Parade
#
# get_coverart Tonic/Lemon\ Parade
#
# get_coverart Tonic/Lemon_Parade
#
# To auto-populate all directories in the current directory, run the following command
#
# find . -type d -exec ./get_coverart "{}" \;
artistalbum="$1"

wget `wget -qO - "http://www.albumart.org/index.php?searchkey=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$artistalbum")&itempage=1&newsearch=1&searchindex=Music" | xmllint --html --xpath  'string(//a[@title="View larger image" and starts-with(@href, "http://ecx.images-amazon")]/@href)' - 2>/dev/null` -qO "$artistalbum.jpg"
