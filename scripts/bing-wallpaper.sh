#!/bin/sh

# Queries the Bing API endpoint and returns a url to today's image.
get_url() {
    INDEX=0
    NUMBER=1
    LOCATION="en-US"
    ROOT="https://www.bing.com"
    API="${ROOT}/HPImageArchive.aspx?format=js&idx=${INDEX}&n=${NUMBER}&mkt=${LOCATION}"

    JSON=$(curl "$API" | tr -d '[:space:]')
    PATH=$(echo "$JSON" | sed -e 's/^.\+"url":"//' -e 's/".\+$//')
    URL="${ROOT}${PATH}"
    echo "$URL"
}

# Extracts the filename from the url of an image.
get_filename() {
    URL="$1"
    FILENAME=$(echo "$URL" | sed -e 's/^.\+\Wid=//' -e 's/&.\+$//')
    echo "$FILENAME"
}

# Downloads an image and returns the download path (while pruning downloaded images if there are too many).
download() {
    if [ -z "$XDG_CACHE_HOME" ]; then
        CACHE="$XDG_CACHE_HOME/bing-wallpaper"
    else
        CACHE="$HOME/.cache/bing-wallpaper"
    fi
    mkdir -p "$CACHE"
    if [ $(ls -A "$CACHE" | wc -l) -gt "10" ]; then
        rm "$CACHE"/*
    fi
    FILE="$CACHE/$2"
    if [ -f "$FILE" ] && file "$FILE" | grep image; then
        echo "$FILE: already downloaded" 1>&2
    else
        curl "$1" --output "$FILE"
    fi
    echo "$FILE"
}

# Sets the wallpaper to a local image.
set_wallpaper() {
    if [ -f "$1" ]; then
        if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
            for prop in $(xfconf-query --channel xfce4-desktop --list | grep last-image); do
                xfconf-query --channel xfce4-desktop --property "$prop" --set "$1"
            done
        else
            echo "Unsupported desktop: ${XDG_CURRENT_DESKTOP}" 1>&2
            exit 1
        fi
    fi
}

URL=$(get_url)
FILENAME=$(get_filename "$URL")
FILE=$(download "$URL" "$FILENAME")
set_wallpaper "$FILE"
