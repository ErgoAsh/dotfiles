{ ... }: {

  flake.modules.homeManager.lock =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            no_fade_in = false;
            grace = 0;
            disable_loading_bar = true;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 2;
              contrast = 0.8916;
              brightness = 0.8172;
              vibrancy = 0.1696;
              vibrancy_darkness = 0.0;
            }
          ];

          input-field = [
            {
              size = "250, 60";
              position = "0, -20";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              check_color = "rgb(249, 226, 175)";
              fail_color = "rgb(243, 139, 168)";
              outline_thickness = 5;
              placeholder_text = "<i>Password...</i>";
              shadow_passes = 2;
            }
          ];

          label = [
            {
              text = "$TIME";
              color = "rgb(202, 211, 245)";
              font_size = 65;
              font_family = "JetBrains Mono";
              position = "0, 100";
              halign = "center";
              valign = "center";
              shadow_passes = 2;
            }
          ];
        };
      };

    };
}
