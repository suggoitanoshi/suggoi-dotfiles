#!/bin/sh

function abs_path { echo $( cd $(dirname $1); pwd -P); }

config_path=$XDG_CONFIG_HOME
[[ -z $conf_path ]] && config_path=$HOME/.config
configs=("dunst/dunstrc" "i3/config" "polybar/config" "rofi/config.rasi" "ncspot/config.toml")

paths="$config_path/i3
$config_path/polybar
$config_path/rofi"

# remove extra files
while IFS= read -r p; do
  for item in $(ls $p | grep -v "backup"); do
    rm "$p/$item"
  done
done <<< "$paths"

# restore backups
for c in ${configs[@]}
do
  if [ ! -f "$config_path/$c.backup" ]; then continue; fi
  mv -f "$config_path/$c.backup" "$config_path/$c"
done
wal_templates=("rofi-dark.rasi" "gtk.css")
template_dir="$config_path/wal/templates"
for t in ${wal_templates[@]}
do
  mv -f "$template_dir/$t.backup" "$template_dir/$t"
done

echo "Done uninstalling."
