{ ... }: {

  flake.modules.homeManager.git =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.git = {
        enable = true;
        settings = {
          credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
          pull.rebase = false;
          user = {
            name = "ErgoAsh";
            email = "3192123+ErgoAsh@users.noreply.github.com";
          };
          init.defaultBranch = "main";
        };
      };

    };
}
