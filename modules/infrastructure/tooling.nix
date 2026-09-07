{ ... }: {
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree;
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.just
        pkgs.nixfmt
        pkgs.git
      ];
    };
  };
}
