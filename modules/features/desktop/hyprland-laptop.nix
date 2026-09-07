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
              output = "desc:Synaptics Inc Non-PnP 0x00BC614E";
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
            };

            gestures = {
              workspace_swipe_distance = 500;
              workspace_swipe_invert = true;
              workspace_swipe_min_speed_to_force = 30;
              workspace_swipe_cancel_ratio = 0.5;
              workspace_swipe_create_new = true;
              workspace_swipe_forever = true;
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
