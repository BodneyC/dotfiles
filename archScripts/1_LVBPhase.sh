#############################################################################
#---------------------------------------------------------------------------#
#-------Name: LVBPhase.sh---------------------------------------------------#
#---------------------------------------------------------------------------#
#-------Info: Work-in-progress shell script for setting up Arch linux-------#
#------------ from boot of live-media to completion. Whilst incomplete,-----#
#------------ this can be used as a guide (specifically for my setup I------#
#-------------suppose) in purley command form.------------------------------#
#---------------------------------------------------------------------------#
#-------NOTE: DO NOT JUST RUN THIS SCRIPT, IT WILL NOT WORK-----------------#
#---------------------------------------------------------------------------#
#############################################################################

# /dev/sdx
fdisk -l
read -p "Installation drive: /dev/" instDrive
# Username
read -p "Username: " USERNAME

# Check internet connection
ping -c 3 google.co.uk
rc=$?
if [[ $rc -ne 0 ]]; then
	echo "Internet connection required"
	exit 1
fi

# Partition prep
echo "mklabel msdos" > ./parted.txt
read -p 'What percent of the disk should be /' rootSz
echo "mkpart primary ext4 1MiB ${rootSz}%" >> ./parted.txt
echo "set 1 boot on" >> ./parted.txt
read -p 'What percent of the disk should be /home' homeSz
echo "mkpart primary ext4 ${rootSz}% $(($homeSz + $rootSz))%" >> parted.txt
echo "mkpart primary linux-swap $(($homeSz + $rootSz))% 100%" >> parted.txt
echo "quit" >> parted.txt
parted /dev/${instDrive} < parted.txt
mkfs.ext4 /dev/${instDrive}1
mkfs.ext4 /dev/${instDrive}2
mkswap /dev/${instDrive}3
swapon /dev/${instDrive}3

# Mounting
mkdir /mnt/home
mount /dev/${instDrive}1 /mnt
mount /dev/${instDrive}2 /mnt/home

# Mirror list
grep -A 1 "## United Kingdom" --group-separator "" /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.backup && grep -A 1 -n "## United Kingdom" /etc/pacman.d/mirrorlist | sed -n 's/^\([0-9]\{1,\}\).*/\1d/p' | sed -f - /etc/pacman.d/mirrorlist >> /etc/pacman.d/mirrorlist.backup
mv /etc/pacman.d/mirrorlist.backup /etc/pacman.d/mirrorlist
# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# sed -i 's/^#Server/Server/g' /etc/pacman.d/mirrorlist.backup
# rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
rm /etc/pacman.d/mirrorlist.backup

# Install base system
pacstrap -i /mnt base base-devel

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

#############################################################################
#---------------------------Chroot into system------------------------------#
arch-chroot /mnt                                                            #
#-------------------------Script needs splitting----------------------------#
#############################################################################

# Locale Config
arch-chroot /mnt /bin/bash -c "sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/g' /ect/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo LANG=en_GB.UTF-8 > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "export LANG=en_GB.UTF-8"
arch-chroot /mnt /bin/bash -c "echo KEYMAP=uk >> /etc/vconsole.conf"

# TimeZone
arch-chroot /mnt /bin/bash -c "echo Europe/London >> /etc/timezone"
arch-chroot /mnt /bin/bash -c "ln -s /usr/share/zoneinfo/Europe/London > /etc/localtime"
arch-chroot /mnt /bin/bash -c "sed -i '/#NTP=/d' /etc/systemd/timesyncd.conf"
arch-chroot /mnt /bin/bash -c "sed -i 's/#Fallback//' /etc/systemd/timesyncd.conf"
arch-chroot /mnt /bin/bash -c "echo \"FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org\" >> /etc/systemd/timesyncd.conf"
arch-chroot /mnt /bin/bash -c "hwclock --systohc --utc"

# Additional tools
arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm dialog wpa_suppliant wireless_tools grub os-prober iw sudo bash-completion python gvim git rofi p7zip wget unzip neovim"

# Boot Loader
arch-chroot /mnt /bin/bash -c "grub-install /dev/${instDrive}"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"

# Host Info
arch-chroot /mnt /bin/bash -c "echo $USERNAME > /etc/hostname"
arch-chroot /mnt /bin/bash -c "printf "Enter root passwd\n""
arch-chroot /mnt /bin/bash -c "passwd --stdin)"

#############################################################################
#-------------------------Exit chroot and reboot----------------------------#
#-----------------------Remove installation media---------------------------#
# exit                                                                      #
umount -R /mnt                                                              #
shutdown now                                                                #
#--------------------------Boot; Login [root:a]-----------------------------#
#-------------------------Script needs splitting----------------------------#
#############################################################################
