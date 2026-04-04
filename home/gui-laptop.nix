{ pkgs, pkgs-unstable, lib, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
  ];

  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
    ];

    settings = {
      monitor = [
        "desc:BOE 0x0A2A, 1920x1200@60, 0x0, 1"
        "desc:Synaptics Inc Non-PnP 0x00BC614E, 1920x1080@60, -1920x0, 1"
        "desc:LG Electronics L1740P 0x00016B3F, 1280x1024@60, -3200x0, 1"
      ];

      workspace = [
        "3, monitor:desc:LG Electronics L1740P 0x00016B3F"
        "4, monitor:desc:LG Electronics L1740P 0x00016B3F"
        "8, monitor:desc:LG Electronics L1740P 0x00016B3F"
        "9, monitor:desc:LG Electronics L1740P 0x00016B3F, default:true"
        "10, monitor:desc:LG Electronics L1740P 0x00016B3F"
        "1, monitor:desc:Synaptics Inc Non-PnP 0x00BC614E, default:true"
        "2, monitor:desc:BOE 0x0A2A, default:true"
        "5, monitor:desc:BOE 0x0A2A"
        "6, monitor:desc:BOE 0x0A2A"
        "7, monitor:desc:BOE 0x0A2A"
      ];

      input = {
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
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

      plugin = {
        touch_gestures = {
          sensitivity = 4.0;
          workspace_swipe_fingers = 3;
          workspace_swipe_edge = "d";
          long_press_delay = 400;
        };
      };

      bind = [
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        "$modifier, Y, exec, wezterm -e yazi"
        "$modifier SHIFT, W, exec, qs-wallpapers-apply"
        "$modifier SHIFT, N, exec, swaync-client -rs"
        "$modifier CTRL, D, exec, dock"
        "$modifier, TAB, exec, qs ipc -c overview call overview toggle"
        "$modifier SHIFT, T, exec, pypr toggle term"
      ];
    };
  };

  programs.waybar.settings.mainBar = {
    modules-right = lib.mkForce [
      "tray"
      "cpu"
      "memory"
      "custom/disk"
      "battery"
      "pulseaudio"
      "clock"
    ];

    battery = {
      interval = 60;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% ({time}) {icon}";
      format-charging = "{capacity}% (Charging) 󰂄";
      format-full = "{capacity}% 󰁹";
      format-plugged = "{capacity}% 󰂄";
      format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      tooltip-format = "{timeTo}";
    };
  };

  programs.waybar.style = ''
    #battery.charging,
    #battery.plugged {
      color: #ffffff;
      background-color: #26a65b;
    }

    #battery.critical:not(.charging) {
      background-color: #f53c3c;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }
  '';

  services.hypridle.settings.listener = [
    {
      timeout = 300;
      on-timeout = "brightnessctl -s set 10";
      on-resume = "brightnessctl -r";
    }
  ];
}
