{ ... }: {

  flake.modules.nixos.greeter =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.customConfig.primaryMonitor = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Primary monitor for display manager (greeter)";
      };

      config = {
        # --- Display manager (greeter) ---
        # Using Regreet sitting on top of Cage (Wayland kiosk)
        programs.regreet = {
          enable = true;
          cursorTheme = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
          };
          settings = {
            background = {
              path = ../../../wallpapers/wallhaven-lyz3d2.png;
              fit = "Cover";
            };
            GTK.application_prefer_dark_theme = true;
          };
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command =
                let
                  monitorArg =
                    if config.customConfig.primaryMonitor != "" then "-m ${config.customConfig.primaryMonitor}" else "";
                  cageCmd = "${pkgs.cage}/bin/cage -s ${monitorArg} -- ${pkgs.regreet}/bin/regreet";
                in
                "${pkgs.dbus}/bin/dbus-run-session sh -lc 'export XCURSOR_SIZE=16; exec ${cageCmd}'";
              user = "greeter";
            };
          };
        };

      };
    };
}
