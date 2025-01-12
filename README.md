In order to install all required packages type:

```shell
export NIX_CONFIG="experimental-features = nix-command flakes"
nix shell nixpkgs#home-manager
sudo nixos-rebuild switch --flake .#hostname
home-manager switch --flake .#username@hostname
nix-collect-garbage
```

