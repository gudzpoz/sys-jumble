#!/bin/sh

FILE="/tmp/scan-on-screen-qt-${RANDOM}.png"

xfce4-screenshooter --region --save "$FILE"
if [ -f "$FILE" ]; then
    qtqr "$FILE"
    rm "$FILE"
else
    echo "Cancelled"
fi
