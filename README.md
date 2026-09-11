<div align="center">

# ❄️ NixOS dotfiles

</div>

Declarative configuration for two NixOS machines, with Home Manager integrated
into each system build. The repository follows the dendritic pattern: files define
named features, profiles compose them, and hosts explicitly select profiles.

## Machines

- `ergo-laptop` — laptop profile and multi-monitor/touch configuration.
- `ergo-pc` — desktop profile with gaming support.

## Repository map

```text
flake.nix                 flake entry point; starts flake-parts + import-tree
modules/
├── features/             programs and capabilities (NixOS and/or Home Manager)
├── profiles/             explicit groups such as base, desktop, laptop, gaming
├── hosts/                profile selection and machine-specific settings
├── hardware/             generated hardware configuration
└── infrastructure/       fleet assembly, shared workspaces and tooling
.agents/skills/           repository-specific Codex workflows
docs/usage.md             everyday operations
wallpapers/               desktop assets
```

Every `.nix` file under `modules/` is a top-level flake-parts module discovered by
import-tree. Discovery defines a named module; it does not enable it on a host.
Open `modules/hosts/ergo-laptop.nix` or `modules/hosts/ergo-pc.nix` to see the
complete profile selection for a machine.

## Bootstrap

On a fresh NixOS installation:

```console
nix-shell -p git --run "git clone https://github.com/ErgoAsh/dotfiles.git ~/dotfiles"
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#ergo-laptop
```

Replace `ergo-laptop` with `ergo-pc` when appropriate.

## Common commands

```console
check-config
build-config
rebuild
```

Fish provides these abbreviations for checking the flake, building the current
host without activation, and rebuilding and activating it. They work from any
directory. The development shell (`nix develop`) supplies `nixfmt` and Git.
See [docs/usage.md](docs/usage.md) for adding, removing, updating and rolling back.

## Desktop

- Window manager: Hyprland (Wayland, Lua configuration)
- Shell: Fish with vi bindings
- Terminal: WezTerm
- Browser: LibreWolf with Tridactyl
- Editor: Helix
- Notes and references: Obsidian and Zotero

Workspace IDs, keys, labels, icons and laptop monitor placement have one source of
truth in `modules/infrastructure/workspaces.nix`.
