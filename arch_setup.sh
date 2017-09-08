#########################################################################
#-----------------------------------------------------------------------#
#----Name: arch_setup.sh------------------------------------------------#
#-----------------------------------------------------------------------#
#----Info: Work-in-progress shell script for setting up Arch linux------#
#--------- from boot of live-media to completion. Whilst incomplete,----#
#--------- this can be used as a guide (specifically for my setup I-----#
#----------suppose) in purley command form.-----------------------------#
#-----------------------------------------------------------------------#
#----NOTE: DO NOT JUST RUN THIS SCRIPT, IT WILL NOT WORK----------------#
#-----------------------------------------------------------------------#
#########################################################################

# Username
read -p "Username: " USERNAME

# Check internet connection
ping -c 3 google.co.uk
rc=$?
if [[ $rc -ne 0 ]]; then
	exit 1
fi

# Partition prep
echo "mklabel msdos" > ./parted.txt
read -p 'What percent of the disk should be /' rootSz
echo "mkpart primary ext4 1MiB ${rootSz}%" >> ./parted.txt
echo "set 1 boot on">> ./parted.txt
read -p 'What percent of the disk should be /home' homeSz
echo "mkpart primary ext4 ${rootSz}% $(($homeSz + $rootSz))%" >> parted.txt
echo "mkpart primary linux-swap $(($homeSz + $rootSz))% 100%" >> parted.txt
echo "quit" >> parted.txt
parted /dev/sda < parted.txt
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3

# Mounting
mkdir /mnt/home
mount /dev/sda1 /mnt
mount /dev/sda2 /mnt/home

# Mirror list
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/g' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
rm /etc/pacman.d/mirrorlist.backup

# Install base system
pacstrap -i /mnt base base-devel

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

#########################################################################
#-------------------------Chroot into system----------------------------#
arch-chroot /mnt														#
#-----------------------Script needs splitting--------------------------#
#########################################################################

# Locale Config
sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/' /ect/locale.gen
locale-gen
echo LANG=en_GB.UTF-8 > /etc/locale.conf
export LANG=en_GB.UTF-8
localectl set-keymap --no-convert uk
echo KEYMAP=uk >> /etc/vconsole.conf
echo KEYMAP=uk >> /etc/rc.conf

# TimeZone
echo Europe/London >> /etc/timezone
ln -s /usr/share/zoneinfo/Europe/London > /etc/localtime
sed -i '/#NTP=/d' /etc/systemd/timesyncd.conf
sed -i 's/#Fallback//' /etc/systemd/timesyncd.conf
echo \"FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org\" >> /etc/systemd/timesyncd.conf
hwclock --systohc --utc

# Additional tools
pacman -S --noconfirm dialog wpa_suppliant wireless_tools grub os-prober iw sudo bash-completion vim git rofi

# Boot Loader
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Host Info
echo $USERNAME > /etc/hostname
printf "Enter root passwd\n"
passwd --stdin)

#########################################################################
#-----------------------Exit chroot and reboot--------------------------#
#---------------------Remove installation media-------------------------#
#------------------------Boot; Login [root:a]---------------------------#
exit																	#
umount -R /mnt															#
shutdown now															#
#-----------------------Script needs splitting--------------------------#
#########################################################################

# Wireless
ip link ### Get device name
systemctl stop dhcpcd@<device-name>.service
wifi-menu -o <device-name> { ### NEEDS AUTOMATING
	follow on-screen instr
}
if netctl start /etc/netctl/<profile>; then
	netctl enable /etc/netctl/<profile>
else
	netctl status /etc/netctl/<profile>
fi
### Check connection
ping -c 3 google.co.uk
rc=$?
if [[ $rc -ne 0 ]]; then
	exit 1
fi

# User control
useradd -m -G wheel,users -s /bin/bash $USERNAME
echo -e "a\na" | (passwd --stdin ${USERNAME})
sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

# Configure repos
sed -i 's/#[multilib]/[multilib]/' /etc/pacman.conf
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/' /etc/pacman.conf
pacman -Sy # update repos

#Install X and ting
pacman -S --noconfirm xorg-server xorg-apps xorg-server-xwayland xorg-xinit xorg-xkill xorg-xinput xf86-input-libinput mesa

printf "1) Nvidia (Nouveau)\n2) AMD\n3) VirtualBox"
read cardMan

if [[ $cardMan -eq 1 ]]; then
    pacman -S --noconfirm xf86-video-nouveau mesa-libgl libvdpau-va-gl
elif [[ $cardMan -eq 2 ]]; then
	pacman -S  --noconfirm xf86-video-ati mesa-libgl mesa-vdpau libvdpau-va-gl
elif [[ $cardMan -eq 3 ]]; then
	pacman -S --noconfirm virtualbox-guest-{dkms,iso,modules,dkms,utils} lib32-mesa
    system_ctl disable ntpd
    system_ctl enable vboxservice
else
	echo "Incorrect choice, ending script"
	exit 1
fi

printf "1) Laptop\n2) Other"
read lapChoice
if [[ $lapChoice -eq 1 ]]; then
	pacman -S --noconfirm xf86-input-synaptics
elif [[ $lapChoice -eq 2 ]]; then
	break
else
	echo "Incorrect choice, ending script"
	exit 1
fi

# Audio configuration
pacman -S --noconfirm alsa-utils pulseaudio
amixer sset Master unmute

# XFCE4 installation
pacman -S --noconfirm xfce4 xfce4-goodies
echo exec startxfce4 > /home/${USERNAME}/.xinitrc


#########################################################################
#-----------------Reboot and login as ${USERNAME}:a---------------------#
reboot 																	#
#------------------------Post-installation------------------------------#
#----------------------------.dotfiles----------------------------------#
#########################################################################

localectl set-keymap uk

mkdir -p ~/{gitclones,Documents/{Current,Programming/{CPP,C,OpenMP,Go,LaTeX}}}

cd ~/gitclones

# Dotfiles
git clone [URL TO BE DECIDED]
cp ./{.bashrc,.bash_aliases,.vimrc,.Xresources} ~/
cp profile /etc/profile
cp local.conf /etc/fonts/

# Xfce4-terminal colourschemes
cd ../
git clone https://github.com/afg984/base16-xfce4-terminal.git
cp -r base16-xfce4-terminal/colorschemes/* /usr/share/xfce4/terminal/colorschemes/

# DroidSansMono
wget https://www.fontsquirrel.com/fonts/download/droid-sans-mono
unzip droid-sans-mono
cp DroidSansMono.ttf /usr/shar/fonts/TTF/
rm droid-sans-mono

# Installing yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
pacman -Sy yaourt
