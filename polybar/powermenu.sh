#!/bin/sh

lk=" Lock"
lg=" Logout"
rb=" Reboot"
sd=" Power off"
c=" Cancel"

sel=$(echo -e "$lk\n$lg\n$rb\n$sd\n$c" | rofi -dmenu -p "" -config $HOME/.config/polybar/powermenu-rofi.rasi -i)
[[ -z $sel ]] && exit
case $sel in
  $lk)
    dm-tool lock ;;
  $lg)
    i3-msg exit ;;
  $rb)
    reboot ;;
  $sd)
    poweroff ;;
  $c) ;;
  *)
    notify-send "Uhhhhhhh" "what???";;
esac
