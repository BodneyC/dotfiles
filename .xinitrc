
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do 
    [ -x "$f" ] && . "$f"
    done
    unset f
fi

udiskie -F &

# BSPWM
exec bspwm
xsetroot -cursor_name left_ptr

# Xfce/Cinnamon
#nm-applet &
# exec startxfce4
#exec cinnamon-session
