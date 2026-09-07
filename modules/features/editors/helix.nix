{ ... }: {

  flake.modules.homeManager.helix =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;

        extraPackages = [
          pkgs.tinymist
          pkgs.typstyle
          pkgs.nixd
          pkgs.nixfmt
        ];

        settings = {
          theme = "catppuccin_mocha_transparent";
          editor = {
            line-number = "relative";
            mouse = true;
          };
        };

        themes.catppuccin_mocha_transparent = {
          inherits = "catppuccin_mocha";
          "ui.background" = { };
        };

        languages = {
          language = [
            {
              name = "typst";
              auto-format = true;
              formatter = {
                command = "typstyle";
              };
            }
            {
              name = "nix";
              auto-format = true;
              formatter = {
                command = "nixfmt";
              };
              language-servers = [ "nixd" ];
            }
          ];
          language-server.nixd = {
            command = "nixd";
          };
        };
      };

      # A stale Home Manager store symlink must not block the whole activation.
      xdg.configFile."helix/config.toml".force = true;

    };
}
