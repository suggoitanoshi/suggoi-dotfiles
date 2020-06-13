#!/bin/sh

stat=$(playerctl status 2>&1)
if [ $stat == "Stopped" -o $stat == "No players found" ]; then exit; fi
[ $stat == "Paused" ] && playpause=" P Play";
[ $stat == "Playing" ] && playpause=" P Pause";
next=" > Next"
prev=" < Prev"

sel=$(echo -e "$playpause\n$next\n$prev" | rofi -dmenu -p "" -config "$HOME/.config/i3/mediacontrol-rofi.rasi" -i )
[[ -z $sel ]] && exit

case $sel in
  $playpause)
    playerctl play-pause ;;
  $next)
    playerctl next ;;
  $prev)
    playerctl previous ;;
esac
