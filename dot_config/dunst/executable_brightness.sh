#!/bin/bash

function get_brightness {
  brightnessctl g
}

function get_max_brightness {
  brightnessctl m
}

function send_notification {
  DIR=`dirname "$0"`
  brightness=`get_brightness`
  max_brightness=`get_max_brightness`
  percent_brightness=$((brightness * 100 / max_brightness))
  bar=$(seq -s "█" $(($percent_brightness)) | sed 's/[0-9]//g')
  icon_name="display-brightness-symbolic"
  $DIR/notify-send.sh "Brightness: ""$percent_brightness%"" " -t 5000 -h int:value:"$percent_brightness" -h string:synchronous:"$bar" --replace=555 -i "$icon_name"
}

case $1 in
  up)
    # Up the brightness (+ 5%)
    brightnessctl s +5%
    send_notification
    ;;
  down)
    # Down the brightness (- 5%)
    brightnessctl s 5%-
    send_notification
    ;;
  get)
    # Get the current brightness
    send_notification
esac
