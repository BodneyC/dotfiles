#############################################################################
#-----------------------Script 3: User-logon phase--------------------------#
#--------------------------Post-installation--------------------------------#
#------------------------------.dotfiles------------------------------------#
#############################################################################

localectl set-keymap uk

mkdir -p ~/{gitclones,.vim/bundle/,Documents/{Current,Programming/{CPP,bash,C,OpenMP,Go/{src,pkg,bin},LaTeX}}}

cd ~/gitclones

# Dotfiles
git clone https://github.com/BodneyC/dotfiles.git
cd dotfiles
cp ./{.bashrc,.bash_aliases,.vimrc,.Xresources,} ~/
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

# DroidSansMono
wget https://www.fontsquirrel.com/fonts/download/droid-sans-mono
unzip droid-sans-mono
cp DroidSansMono.ttf /usr/share/fonts/TTF/
rm droid-sans-mono

# Installing yaourt
echo "[archlinuxfr]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
pacman -Sy --noconfirm yaourt

# Languages
choiceVar = 1
while [[ $choiceVar -ne 0 ]]; do
	printf "Languages\n---------\n 1) TeX\n 2) Go\n\n 0) Continue..."
	read choiceVar
	case "$choiceVar" in
		1)
			pacman -S texlive-most texlive-lang
			;;
		2)
			pacman -S go
			;;
		0)
			;;
	esac
done

# Additional apps
pacman -S atom htop firefox qbittorrent steam
yaourt -S discord spotify
