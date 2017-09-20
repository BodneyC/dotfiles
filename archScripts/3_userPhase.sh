#############################################################################
#---------------------------------------------------------------------------#
#-------Name: userPhase.sh--------------------------------------------------#
#---------------------------------------------------------------------------#
#-------Info: This script concerns commands after the creation of the main--#
#-------------user and the installation and configuration of a window-------#
#-------------manager. Personal touches and dotfile copying.----------------#
#---------------------------------------------------------------------------#
#-------NOTE: DO NOT JUST RUN THIS SCRIPT, IT WILL NOT WORK-----------------#
#---------------------------------------------------------------------------#
#############################################################################

mkdir -p ~/{gitclones,.vim/bundle/,Documents/{Current,Programming/{CPP,bash,C,OpenMP,Go/{src,pkg,bin},LaTeX}}}

cd ~/gitclones

# Dotfiles
git clone https://github.com/BodneyC/dotfiles.git
cd dotfiles
cp ./{.bashrc,.bash_aliases,.vimrc,.Xresources,.xinitrc,.bash_profile} ~/
sed -i "/s/e\/\/D/e\/${USERNAME}\/D" profile
cp profile /etc/profile
cp local.conf /etc/fonts/

# Vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
pacman -S --noconfirm build-essential clang cmake
vim +PluginInstall +quall && cd .vim/bundle/YouCompleteMe/
./install.py --clang-completer --system-libclang --gocode-completer

# Xfce4-terminal colourschemes
cd ~/gitclones
git clone https://github.com/afg984/base16-xfce4-terminal.git
cp -r base16-xfce4-terminal/colorschemes/* /usr/share/xfce4/terminal/colorschemes/

# XFCE4 THEMES
tar -xvf [vertex_thing].tar.gz
cp -r Vertex* /usr/share/themes
wget https://dl.opendesktop.org/api/files/download/id/1461767736/90145-axiom.tar.gz
cp -r axiom* /usr/share/themes/

# XFCE4 FONT
	# DroidSans
wget https://www.fontsquirrel.com/fonts/download/droid-sans-mono
wget https://www.fontsquirrel.com/fonts/download/droid-sans
unzip droid-sans-mono
unzip droid-sans
cp DroidSansMono* /usr/share/fonts/TTF/

# XFCE4 ICONS
git clone https://github.com/vinceliuice/vimix-icon-theme.git
cp -r vimix-icon-theme/{Paper-Vimix/,Vimix/} /usr/share/icons/
gtk-update-icon-cache /usr/share/icons/{Paper-Vimix,Vimix}


# Installing yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
pacman -Sy --noconfirm yaourt

# Additional apps
pacman -S atom htop firefox qbittorrent steam
yaourt -S discord spotify
