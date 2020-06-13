#!/bin/sh

# THIS SCRIPT RELIES ON PYWAL
[ ! -x "$(command -v wal)" ] && echo "wal not detected in \$PATH" && exit 1

function abs_path { echo $( cd $(dirname $1); pwd -P); }

# check config path
conf_path=$XDG_CONFIG_HOME
[ -z $conf_path ] && conf_path=$HOME/.config

script_path=$(abs_path $0)

# add custom templates
templates=("rofi-dark.rasi" "gtk.css")
template_src="$script_path/pywal_template/"
template_target="$conf_path/wal/templates/"
for file in ${templates[@]}
do
  target="$template_target/$file"
  [ -f "$target" ] && cp -f "$target" "$target.backup"
  ln -sf "$template_src/$file" "$target"
done

# generate pywal themes
wal --theme "$script_path/theme.json"

# create config directories if not exists
configs=("$conf_path/dunst/dunstrc" "$conf_path/i3/config" "$conf_path/rofi/config.rasi" "$conf_path/ncspot/config.toml")
mkdir -p $(dirname ${configs[@]})

# create backup for original config
for file in ${configs[@]}
do
  [ -f "$file" ] && cp -f "$file" "$file.backup"
done

# symlink files to their respective directories
ln -sf $script_path/dunst/dunstrc $conf_path/dunst/dunstrc
ln -sf $script_path/i3/* $conf_path/i3/
ln -sf $script_path/polybar/* $conf_path/polybar/
ln -sf $script_path/rofi/config.rasi $conf_path/rofi/config.rasi
ln -sf $script_path/ncspot/config.toml $conf_path/ncspot/config.toml

for i in $script_path/i3/* $script_path/polybar/*; do
  if [ -z $(echo $i | grep ".sh") ]; then chmod +x $i; fi
done

# symlink wal-generated theme
ln -sf $HOME/.cache/wal/rofi-dark.rasi $conf_path/rofi/rofi-dark.rasi
ln -sf $HOME/.cache/wal/gtk.css $conf_path/gtk-3.0/gtk.css

echo "Done installing."
