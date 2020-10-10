# Load configs
xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
xbindkeys
udiskie &

xset +fp /home/natskyge/.fonts
xset fp rehash

# Background image
feh --bg-fill "$HOME/usr/images/wallpaper/New_York.jpg"

# Statusbar
bar | lemonbar -a 5 -b -d -p -f "scientifica:size=11:style=bold" -f '-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1' -B "#121c21" -F "#aaafb2" -g 1366x40+0+0 | sh &

# Compton
compton --config ~/.config/compton/compton.conf -b

# sxhkd
# sxhkd -c $HOME/.config/sxhkd/sxhkdrc &

#windowchef&
2bwm&
exec st

redshift
