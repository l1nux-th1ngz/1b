#!/bin/bash

# Update package list and install bspwm
sudo apt-get update
sudo apt-get -y install bspwm

# Install additional utilities and applications
sudo apt-get -y install nemo ranger xdg-user-dirs xdg-user-dirs-gtk
xdg-user-dirs-update
xdg-user-dirs-gtk-update

# Install Qt5 style for Kvantum and other utilities
sudo apt-get -y install --no-install-recommends qt5-style-kvantum
sudo apt-get -y install yq jq libnotify-bin libnotify4 lxappearance

# Terminals 
sudo apt-get -y install kitty alacritty geany geany-plugins exa trayer vifm volumeicon-alsa brightnessctl xclip maim xautolock i3lock

# Other utilities and libraries
sudo apt-get -y install rofi xbindkeys dex acpi wmctrl playerctl dunst xbacklight libghc-xmonad-contrib-doc xclip maim xdotool xorg xinit scrot imagemagick xinput build-essential bluez blueman sxhkd polybar acpid avahi-daemon xserver-xorg libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

# Enable services
sudo systemctl enable bluetooth
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Set up .xinitrc
cat << 'EOF' > ~/.xinitrc
#!/bin/sh
sxhkd &
exec bspwm
EOF

# Install and configure picom
git clone https://github.com/FT-Labs/picom ~/bookworm-scripts/picom
cd ~/bookworm-scripts/picom
meson setup --buildtype=release build
ninja -C build
sudo ninja -C build install

# Create necessary configuration directories
mkdir -p ~/.config/{bspwm,sxhkd,polybar,dunst,rofi,picom,eww}

# Copy default configuration files
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
cp /etc/xdg/picom.conf ~/.config/picom/
cp /etc/polybar/config.ini ~/.config/polybar/
cp /etc/dunst/dunstrc ~/.config/dunst/

# Set bspwmrc executable
chmod +x ~/.config/bspwm/bspwmrc

# Configure bspwmrc
cat << 'EOF' >> ~/.config/bspwm/bspwmrc
# Autostart
sxhkd &
picom --config $HOME/.config/picom/picom.conf &
dunst &
polybar &
bspc monitor -d web dev dir txt vid pad mus gfx dis obs

# bspwm settings
bspc config border_width 4
bspc config window_gap 10
bspc config split_ratio 0.5
bspc config single_monocle false
bspc config focus_follows_pointer true
bspc config borderless_monocle true
bspc config gapless_monocle true
bspc config presel_feedback_color "#1a1a1a"
bspc config active_border_color "#4fc3f7"
bspc config focused_border_color "#4fc3f7"
bspc config normal_border_color "#1a1a1a"

# Rules
bspc rule -a "*" split_dir=east
bspc rule -a qimgv state=floating
bspc rule -a sxiv state=floating
bspc rule -a Xarchiver state=floating layer=normal
bspc rule -a mpv state=floating layer=normal
bspc rule -a Pavucontrol:pavucontrol state=floating 
bspc rule -a Lxappearance state=floating layer=normal
bspc rule -a kitty state=floating layer=normal sticky=on 
bspc rule -a 'GitHub Desktop' desktop='^2' follow=on
bspc rule -a Gimp desktop='^8' follow=on
bspc rule -a obs desktop='^10' follow=on
bspc rule -a discord desktop='^9' follow=on

# Startup
xsetroot -cursor_name left_ptr &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
feh --bg-fill ~/.config/backgrounds/wallhaven-m3w6pk_3440x1440.png &
~/.config/bspwm/polybar-bspwm &
EOF

# Configure sxhkdrc
cat << 'EOF' > ~/.config/sxhkd/sxhkdrc
# Basic keybindings
super + b
	brave

super + p
	firefox

super + Return
	kitty

super + t
	alacritty

super + space
   	rofi -show drun -modi drun -line-padding 4 -hide-scrollbar -show-icons 
   	
super + o
	thunar

super + g
	geany

super + q

# Quit/restart bspwm
ctrl + alt + del
	bspc {quit}

# Set the window state
super + shift + {t,s,f}
	bspc node -t {tiled,floating,fullscreen}

super + Escape
	pkill -USR1 -x sxhkd; notify-send 'sxhkd' 'Reloaded config'
	
bspc node -s {west,south,north,east}

# Change workspace with dunst feedback
ctrl + {Left,Right}
	bspc {desktop --focus,node --to-desktop} 'focused:^{1-9,10}' --follow

# Resize tiling windows
super + ctrl + {Left,Down,Up,Right}
	bspc node -z left -40 0; bspc node -z right -40 0
	bspc node -z bottom 0 40; bspc node -z top 0 40
	bspc node -z bottom 0 -40; bspc node -z top 0 -40
	bspc node -z left 40 0; bspc node -z right 40 0

# Scrot keybindings
super + @Print
	scrot -s -e 'mv $f ~/Screenshots'; \
	notify-send 'Scrot' 'Selected image to ~/Screenshots'

@Print
	scrot -e 'mv $f ~/Screenshots'; \
	notify-send 'Scrot' 'Image saved to ~/Screenshots'
EOF

# Install LightDM, LightDM GTK+ Greeter, and Slick Greeter without recommendations
sudo apt-get update
sudo apt-get -y --no-install-recommends install lightdm lightdm-gtk-greeter slick-greeter

# Configure LightDM greeters
sudo mkdir -p /etc/lightdm/lightdm-gtk-greeter.conf.d/
sudo mkdir -p /etc/lightdm/slick-greeter.conf.d/

echo "[greeter]
show-indicators=~language;~session;~a11y;~clock
clock-format=%I:%M %p
show-hostname=false
show-username=true
" | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf.d/01_myconfig.conf

echo "[Greeter]
show-indicators=~language;~session;~a11y;~clock
clock-format=%I:%M %p
show-hostname=false
show-username=true
" | sudo tee /etc/lightdm/slick-greeter.conf.d/01_myconfig.conf

# Restart LightDM to apply changes
sudo systemctl restart lightdm
