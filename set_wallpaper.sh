#!/bin/sh

[[ -z "$1" ]] && echo "Provide a path to wallpaper." && exit 1
[[ ! -f "$1" ]] && echo "$1 is not a valid file." && exit 1

ln -sf "$1" $HOME/wallpaper/w
i3-msg restart
