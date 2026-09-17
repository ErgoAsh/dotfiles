{ ... }: {

  flake.modules.homeManager.satty =
    {
      lib,
      pkgs,
      ...
    }:
    let
      screenshotRegion = pkgs.writeShellApplication {
        name = "screenshot-region";
        runtimeInputs = with pkgs; [
          grim
          satty
          slurp
        ];
        text = ''
          if ! geometry="$(slurp -d)"; then
            exit 0
          fi

          grim -g "$geometry" -t ppm - | satty --filename -
        '';
      };
    in
    {
      programs.satty = {
        enable = true;
        settings.general = {
          fullscreen = "current-screen";
          early-exit = true;
          corner-roundness = 12;
          initial-tool = "pointer";
          copy-command = "wl-copy";
          output-filename = "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png";
          actions-on-enter = [ "save-to-clipboard" ];
          actions-on-escape = [ "exit" ];
          actions-on-right-click = [ "save-to-clipboard" ];
        };
      };

      home.packages = [ screenshotRegion ];

      home.activation.createScreenshotsDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$HOME/Pictures/Screenshots"
      '';
    };
}
