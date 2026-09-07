# Dotfiles: working agreements

## Scope and architecture
- This repository manages NixOS with Home Manager integrated as a NixOS module.
- The repository follows the dendritic pattern. Apart from `flake.nix`, every Nix
  file is a flake-parts module discovered through `import-tree`.
- `modules/features/` owns reusable behavior, possibly across NixOS and Home
  Manager. `modules/profiles/` composes features. `modules/hosts/` selects profiles
  and contains host choices. Generated hardware settings live in `modules/hardware/`.
- `modules/infrastructure/` defines fleet assembly, Home Manager integration,
  shared data and development tooling. It is infrastructure, not a host profile.
- Exported hosts are `ergo-laptop` and `ergo-pc`. Treat `flake.nix`, named modules
  and `dotfiles.hosts` as the source of truth.

## Changes
- Use the `dotfiles-program` skill for adding, removing, or updating programs.
- Preserve unrelated working-tree changes. Inspect the diff before editing.
- The user prefers stable. Preserve existing exceptions; explain why stable cannot
  meet the request before proposing unstable or new custom packaging.
- Prefer an existing Home Manager program module when it manages the needed
  configuration. Use `home.packages` for user packages without such configuration.
  Put system services, drivers and system integration in NixOS modules.
- Follow imports to determine affected hosts. Ask when requested host scope is
  ambiguous and would change which machines receive a program.
- Preserve Hyprland's Lua configuration and `modules/infrastructure/hyprland-lua.nix` helpers.
  Do not paste legacy configuration syntax into these settings.
- Add code comments only when the user explicitly requests them. Inside embedded
  Lua strings, use Lua comment syntax (`--`), not Nix comment syntax (`#`).
- Keep package overrides and compatibility patches until their reason no longer
  applies and that has been verified. Do not change stateVersion as an update step.
- An ordinary program task covers edits and validation. Activate with
  `nixos-rebuild switch` only when the user requests activation. Existing explicit
  authorization remains valid; do not ask again unnecessarily.
- Removing a declaration does not authorize deleting personal application data,
  old system generations or shared dependencies still used by other programs.

## Validation
- Format only changed Nix files, e.g. `nixfmt modules/features/apps/packages.nix`; the flake formatter
  is `nixfmt-tree`. Avoid formatting unrelated user changes.
- Discover hosts: `just hosts`, or use
  `nix eval --no-write-lock-file --json .#nixosConfigurations --apply builtins.attrNames`.
- Evaluate each affected host, e.g.:
  `nix eval --no-write-lock-file --raw .#nixosConfigurations.ergo-laptop.config.system.build.toplevel.drvPath`.
  Shared changes require both exported hosts; replace the host name for PC.
- Build affected system configurations when needed to verify package or activation
  closure changes: `nix build --no-write-lock-file --no-link .#nixosConfigurations.ergo-laptop.config.system.build.toplevel`.
  A successful evaluation alone does not establish that a package builds or runs.
- New files must be visible to the flake source. Git flakes omit untracked files:
  inspect and stage only intended files when appropriate; never use `git add .`
  as a validation shortcut. Do not commit as part of validation.
- Documentation-only changes need link/content review, not system builds.
- Report which checks actually ran, failures or environmental blockers, affected
  hosts, and whether activation occurred. Do not claim runtime validation from a build.
