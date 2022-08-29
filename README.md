<h1 align=center>ErgoAsh's dotfiles</h1>

## Arch installation
/etc/iwd/main.conf
systemctl enable --now iwd
systemctl enable --now systemd-resolved

## Internet connection services (run by *systemctl*): 
* iwd (run station device connect SSID)
* systemd-resolved

## Kernel commands 
initrd: amd-ucode.img
initd: initramfs-linux.img
root=PARTUUID=uuid rw

## AUR installation 
* base-devel
* yay/paru

### Environment packages 
* xorg (xorg-server xorg-init xorg-xrandr xorg-setxkbmap)
* AMD graphics (xf86-video-amdgpu mesa lib32-mesa)
* alsa-utils (pipewire pipewire-jack)
* python (python-pip pynvim)
* rust

## Dotfiles installation 
* git clone --bare https://github.com/ErgoAsh/dotfiles.com $HOME/.dotfiles
* /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout

## Environment utilities 
* nvim-packer-git
* dunst 
* zsh (zsh-completion oh-my-zsh zsh-theme-powerlevel10k-git)
* kitty

### i3 installation 
* Change login shell to zsh in /etc/passwd
* i3lock-color

### Additions 
* polybar
* ncspot (ncspot-cover)
* neofetch
* qalculate (libqualculate)
* qutebrowser
* rofi
* zathura
* taskwarrior (task)
* pcloud (pcloud-drive)
* feh
* discord
* anki
* flameshot

#### Credentials 
* git-credential-manager-core
* bitwarden
* gnupg
* pass

### Visuals 
* ttf-dejavu (ttf-fira-code-git ttf-nerd-fonts-symbols)
* fc-list
* picom-git

### Package backlog (todo's) 
* i3-swallow: https://github.com/jamesofarrell/i3-swallow 
* xidlehook: https://gitlab.com/jD91mZM2/xidlehook
* bitwarden-rofi: https://github.com/haztecaso/bitwarden-rofi
* lutris
* inkscape
* qjackctl (PulseAudio)
* steam 
* latex distro
