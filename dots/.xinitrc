# Load configs
xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
xbindkeys
udiskie &

xset +fp /home/natskyge/.fonts
xset fp rehash

# Background image
feh --bg-fill "$HOME/usr/images/wallpaper/flower-iceland6.jpg"

# Statusbar
bar | lemonbar -a 5 -b -d -p -f "scientifica:size=11" -f '-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1' -B "#00000000" -F "#EEFFFF" -g 1336x40+15+15 &

# Compton
compton --config ~/.config/compton/compton.conf -b

2bwm&
exec st
