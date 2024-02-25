#!/bin/bash

function get_volume {
  ags -r 'indicator.speaker()'
}

function is_mute {
  pamixer --get-mute
}

function toggle_mute {
  if $(is_mute) ; then
    pamixer -u > /dev/null
    mute_state="Unmuted"
  else
    pamixer -m > /dev/null
    mute_state="Mute"
  fi
  send_notification "$mute_state"
}

function send_notification {
  DIR=`dirname "$0"`
  volume=`get_volume`
  bar=$(seq -s "█" $(($volume/5)) | sed 's/[0-9]//g')
  if [ "$1" = "Mute" ]; then
    icon_name="audio-volume-muted-symbolic"
    $DIR/notify-send.sh "$1""      " -i "$icon_name" -t 5000 -h int:value:"$volume" -h string:synchronous:"█" --replace=555
  else
    if [  "$volume" -lt "10" ]; then
      icon_name="audio-volume-low-symbolic"
    elif [ "$volume" -lt "30" ]; then
      icon_name="audio-volume-low-symbolic"
    elif [ "$volume" -lt "70" ]; then
      icon_name="audio-volume-medium-symbolic"
    else
      icon_name="audio-volume-high-symbolic"
    fi
    $DIR/notify-send.sh "$1""  "$volume"   " -i "$icon_name" -t 5000 -h int:value:"$volume" -h string:synchronous:"$bar  " --replace=555
  fi
}

case $1 in
  up)
    # Set the volume on (if it was muted)
    pamixer -u > /dev/null
    # Up the volume (+ 5%)
    pamixer -i 5 > /dev/null
    send_notification
    ;;
  down)
    pamixer -u > /dev/null
    pamixer -d 5 > /dev/null
    send_notification
    ;;
  mute)
    # Toggle mute
    toggle_mute
    ;;
  get)
    send_notification
esac
