{ config, ... }:
let
  flakeConfig = config;
  ws = config.dotfiles.workspaces;
in
{

  flake.modules.homeManager.hyprland-laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      h = flakeConfig.dotfiles.hyprlandLua lib;
      inherit (h)
        bindMod
        bindModOpts
        bindKey
        execCmd
        ;
    in
    {
      home.packages = [ pkgs.wvkbd ];

      systemd.user.services.wvkbd = {
        Unit = {
          Description = "On-screen keyboard";
          After = [ "hyprland-session.target" ];
          PartOf = [ "hyprland-session.target" ];
        };
        Service = {
          ExecStart = toString (
            pkgs.writeShellScript "start-wvkbd" ''
              exec ${pkgs.wvkbd}/bin/wvkbd-mobintl \
                --hidden \
                -H 480 \
                -L 360 \
                --fn "FiraCode Nerd Font 20" \
                -l full,special,emoji,nav \
                --landscape-layers landscape,landscapespecial,emoji,nav
            ''
          );
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "hyprland-session.target" ];
      };

      wayland.windowManager.hyprland = {
        settings = {
          monitor = [
            {
              output = "desc:BOE 0x0A2A";
              mode = "1920x1200@60";
              position = "1920x0";
              scale = 1;
            }
            {
              output = "desc:Lenovo Group Limited E22-20 VY036074";
              mode = "1920x1080@60";
              position = "0x0";
              scale = 1;
            }
            {
              output = "desc:Iiyama North America PL1906 11013A9702441";
              mode = "1280x1024@60";
              position = "-1280x0";
              scale = 1;
            }
          ];

          workspace_rule =
            map
              (
                w:
                {
                  workspace = toString w.id;
                  monitor = w.laptopMonitor;
                }
                // lib.optionalAttrs w.laptopDefault { default = true; }
              )
              [
                ws.editors
                ws.music
                ws.mail
                ws.tasks
                ws.study
                ws.browser
                ws.terminal
                ws.chat
                ws.notes
                ws.references
                ws.audio
                ws.chatgpt
              ];

          config = {
            input = {
              touchpad = {
                natural_scroll = true;
                tap_to_click = true;
                disable_while_typing = true;
              };

              touchdevice = {
                output = "eDP-1";
                transform = 0;
              };

              tablet = {
                output = "eDP-1";
                transform = 0;
              };
            };

            gestures = {
              workspace_swipe_distance = 500;
              workspace_swipe_invert = true;
              workspace_swipe_min_speed_to_force = 30;
              workspace_swipe_cancel_ratio = 0.15;
              workspace_swipe_create_new = true;
              workspace_swipe_forever = true;
              workspace_swipe_touch = true;
            };

          };

          bind = [
            (bindKey "XF86MonBrightnessDown" (execCmd "brightnessctl set 5%-"))
            (bindKey "XF86MonBrightnessUp" (execCmd "brightnessctl set +5%"))
            (bindMod "Y" (execCmd "wezterm -e yazi"))
            (bindModOpts "SHIFT + W" (execCmd "qs-wallpapers-apply") { })
            (bindModOpts "SHIFT + N" (execCmd "swaync-client -rs") { })
            (bindModOpts "CTRL + D" (execCmd "dock") { })
            (bindMod "TAB" (execCmd "qs ipc -c overview call overview toggle"))
            (bindModOpts "SHIFT + T" (execCmd "pypr toggle term") { })
          ];

        };

      };

    };
}
