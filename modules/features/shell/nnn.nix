{ ... }: {

  flake.modules.homeManager.nnn =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.nnn = {
        enable = true;
        package = pkgs.nnn.override { withNerdIcons = true; };
        plugins = {
          src =
            (pkgs.fetchFromGitHub {
              owner = "jarun";
              repo = "nnn";
              rev = "v4.9";
              sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
            })
            + "/plugins";
        };
      };

    };
}
