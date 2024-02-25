#!/bin/bash

selected=$(cat ~/.config/thorium/Default/Bookmarks | grep '"url":' | awk '{print $2}' | sed 's/"//g' | rofi -dmenu -p "Select a Thorium Bookmark")

if [ "$selected" ]; then
    thorium-browser $selected
fi

