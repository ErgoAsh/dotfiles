# ❄️ NixOS dotfile configuration

My personal declarative configuration for NixOS, managing my laptop, PC, and servers via **Nix Flakes** and **Home Manager**.

## 🚀 Bootstrap (fresh install)

To set up this configuration on a fresh machine with NixOS installed, run:

```bash
# 1. Clone the repo
nix-shell -p git --run "git clone https://github.com/ErgoAsh/dotfiles.git ~/dotfiles"

# 2. Enter directory
cd ~/dotfiles

# 3. Apply the configuration
# Replace 'HOSTNAME' with: ergo-laptop, ergo-pc, ergo-home-server or ergo-flat-server
sudo nixos-rebuild switch --flake .#HOSTNAME --option extra-experimental-features "nix-command flakes"
```

## 📂 Structure
* `flake.nix`: The entry point and fleet definition.
* `hosts/`: Machine-specific configurations (hardware, boot, networking).
* `home/`: User-space configurations (Helix, Fish, Browser, Apps).

## 🛠️ Main tools
* **Shell:** Fish + Starship
* **Editor:** Helix (with LSP support for Nix, Typst, Python)
* **Browser:** LibreWolf + Tridactyl
* **Terminal:** Rio
* **Media:** VLC, Zathura (PDF)

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
