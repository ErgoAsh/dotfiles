{ ... }: {
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree;
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.nixfmt
        pkgs.git
      ];
    };
  };
}
