<br/><br/>
<h1 align=center>ErgoAsh's dotfiles</h1>

## Arch installation
* setuptime zone with timedatectl
    ```
    timedatectl set-ntp true
    timedatectl set-timezone Europe/Poland
    ```
* create disk partitions using fdisk or parted
    ```
    lsblk # to view existing hard drive devices
    parted
    ```
    Parted subcommands:
    ```
    print list
    mkpart "EFI" fat32 1MiB 301MiB
    mkpart "Arch SWAP" linux-swap 301MiB 8GiB
    mkpart "Arch ROOT" ext4 8GiB 183GiB
    
    set 1 esp on
    ```
    You can use e.g. 100% instead of 183GiB (175 + 8) to set maximum size
* format partitions
    ```
    mkfs.fat -F 32 /dev/nvme0n1p1
    mkswap /dev/nvme0n1p2
    mkfs.ext4 /dev/nvme0n1p3
    
    ```
* mount partitions
    ```
    mount --mkdir /dev/nvme0n1p1 /mnt/boot
    swapon /dev/nvme0n1p2
    mount /dev/nvme0n1p3 /
    
    ```
* install linux using pacstrap
    ```
    pacstrap /mnt base linux linux-firmware
    ```
* update /etc/fstab on /mnt
    ```
    genfstab -U /mnt >> /mnt/etc/fstab
    ```
* switch to new system on /mnt
    ```
    arch-chroot /mnt
    ```

### Elementary sofware installation
* install base-devel rustup git nvim
* edit /etc/sudoers and uncomment wheel group
* rustup default stable
* useradd -m -G wheel ergoash
* Install paru on user
* paru -S neovim-git
* set hostname: /etc/hostname
* man-pages man-db

### Bootloader
* bootctl install
* amd-ucode install
* edit /boot/loader/loader.conf
    ```
    default arch.conf
    timeout 3
    console-mode max
    editor no
    ```
* create /boot/loader/entries/arch.conf
    ```
    title Arch Linux
    linux /vmlinux-linux
    intrd /amd-ucode.img
    intrd /initramfs-linux.img
    ```
    Add last line using:
    ```
    echo "options root=PARTUUID=$(blkid -s PARTUUID -o vlaue /dev/nvme0n1p3) rw" >> /mnt/boot/loader/entries/arch.conf
    ```

## Internet connection services (run by *systemctl*): 
* iwd (run station device connect SSID)
* dhcpcd
* /etc/iwd/main.conf
    ```
    [General]
    EnableNetworkConfiguration=true

    [Network]
    NameResolvingService=systemd
    ```
* systemd-networkd
* systemd-resolved

* systemctl enable --now iwd
* systemctl enable --now dhcpcd
* systemctl enable --now systemd-resolved
* systemctl enable --now systemd-networkd

* Change /etc/resolv.conf and /run/systemd/resolve/resolv.conf (nameserver 1.1.1.1) to set DNS is `gh auth login` doesn't work

### After reboot
* ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
* hwclock --systohc

### Environment packages 
* xorg (xorg-server xorg-init xorg-xrandr xorg-setxkbmap)
* AMD graphics (xf86-video-amdgpu mesa lib32-mesa)
    * /etc/pacman.conf
    * Uncomment multilib repository
* alsa-utils (pulseaudio-alsa pipewire pipewire-jack)
    * set default devices at /etc/pulse/default.pa
* python (python-pip pynvim)

## Dotfiles installation 
* git clone --bare https://github.com/ErgoAsh/dotfiles.com $HOME/.dotfiles
* git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout

### Git configuration
* github-cli
* gh auth login
* 
## Environment utilities 
* nvim-packer-git
* dunst 
* zsh (zsh-completion oh-my-zsh zsh-theme-powerlevel10k-git)
* kitty

### i3 installation 
* Change login shell to zsh in /etc/passwd
* i3-gaps-next-git
* i3lock-color

### Additions 
* polybar
* ncspot (ncspot-cover)
* neofetch
* qalculate (libqualculate)
* qutebrowser (pdfjs pip:tldextract)
* rofi
* zathura
* taskwarrior (task)
* pcloud (pcloud-drive)
* feh
* discord
* anki
* flameshot
* brightnessctl (for setting brightness)
* bitwarden-cli (pip install tldextract)
* obsidian
* glances

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
* latex distro

### Jupyter Lab
* pacman -S jupyterlab
* pip install jupyterlab-vim
* pip install jupyterlab-spreadsheet-editor
* pip install matplotlib
* pip install numpy
* pip install pandas
* pip install SciencePlots

## Post-installation maintenance
* inside nvim: :PackerInstall, :PackerCompile
* chsh -s /usr/bin/zsh
