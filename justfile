set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

hosts:
    nix eval --no-write-lock-file --json path:.#nixosConfigurations --apply builtins.attrNames

check:
    nix flake check --no-build --no-write-lock-file path:.

build host:
    nix build --no-link --no-write-lock-file "path:.#nixosConfigurations.{{host}}.config.system.build.toplevel"

switch host:
    sudo nixos-rebuild switch --flake "path:.#{{host}}"
