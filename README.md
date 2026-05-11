<div align="center">

# ❄️ NixOS dotfile configuration

</div>

My personal declarative configuration for NixOS, managing my laptop and PC via **Nix Flakes** and **Home Manager**.

## Bootstrap (fresh install)

To set up this configuration on a fresh machine with NixOS installed, run:

```bash
# 1. Clone the repo
nix-shell -p git --run "git clone https://github.com/ErgoAsh/dotfiles.git ~/dotfiles"

# 2. Enter directory
cd ~/dotfiles

# 3. Apply the configuration
# Replace 'HOSTNAME' with: ergo-laptop, ergo-pc, or ergo-vm
sudo nixos-rebuild switch --flake .#HOSTNAME --option extra-experimental-features "nix-command flakes"
```

## Structure
```
dotfiles/
├── flake.nix           # Main entry point and fleet definition
├── hosts/              # Machine-specific configurations
│   ├── ergo-laptop/    # Laptop configuration
│   ├── ergo-pc/        # Desktop PC configuration
│   └── ergo-vm/        # VM configuration
├── home/               # User-space configurations (home-manager)
│   ├── apps.nix        # GUI applications and programs
│   ├── gui.nix         # Hyprland, Waybar, window rules
│   ├── gui-laptop.nix  # Laptop-specific GUI settings
│   ├── shell.nix       # Shell configuration (Fish)
│   └── games.nix       # Gaming-related packages
├── modules/            # Reusable NixOS modules
│   ├── core.nix        # Base system configuration
│   ├── desktop.nix     # Desktop environment setup
│   ├── laptop.nix      # Laptop-specific settings
│   └── gaming.nix      # Gaming configuration
└── wallpapers/         # Desktop wallpapers
```

## Main tools
* **Window Manager:** Hyprland (Wayland)
* **Shell:** Fish with vi keybindings
* **Terminal:** WezTerm
* **Browser:** LibreWolf + Tridactyl
* **Editor:** Helix
* **Notes:** Obsidian
* **Reference Manager:** Zotero
* **Communication:** Vesktop (Discord), Thunderbird

## Workspace layout
1. LibreWolf
2. Terminal
3. IDEs
4. Spotify
5. Discord
6. Obsidian
7. Zotero
8. Thunderbird
9. TickTick
10. Anki (key: 0)
11. Ardour (key: \)

## Utility commands

Update dotfiles after changes:

```shell
cd ~/dotfiles
git add .
sudo nixos-rebuild switch --flake .#HOSTNAME
```

Remove NixOS garbage manually (automatic cleanup is set to every 7 days):

```shell
sudo nix-collect-garbage -d
```

