alias q="shutdown -h now"
alias bodstall="sudo pacman -S"
alias bodyao="yaourt -S"
alias l="ls -sa"
alias ls="ls -ls"
alias texclean="rm *.log *.aux *.toc *.lof *.lot *.out *.dvi"
alias batt='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "native-path|state|to\ full|percentage|time\ to\ empty"'
# alias vim="nvim"
alias sunvim="sudo -E nvim"
# alias rm="trash"
alias watch_power='watch upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "native-path|state|to\ full|percentage|time\ to\ empty"'
