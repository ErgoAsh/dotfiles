{ pkgs, inputs, ... }:

let
  wallpaper = ../wallpapers/wallhaven-lyz3d2.png;
in
{
  home.packages = with pkgs; [
    waybar
    swww
    gammastep
    networkmanagerapplet
    libnotify
    mako
    blueman

    wl-clipboard # Clipboard manager
    grim # Screenshot tool
    slurp # Screen area selection
    swappy # Screenshot editor
    pavucontrol # Audio control GUI
    brightnessctl # Screen brightness control
    playerctl # Media player control
    nerd-fonts.fira-code
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
    ];

    settings = {
      windowrulev2 = [
        "workspace 1 silent, class:^([Ll]ibre[Ww]olf)$"
        "workspace 2, class:^([Rr]io)$"
        "workspace 3 silent, class:^(jetbrains-.*)$"
        "workspace 3 silent, class:^(code-url-handler|code-oss|Code)$"
        "workspace 4 silent, class:^([Oo]bsidian)$"
        "workspace 5 silent, class:^([Vv]esktop|[Dd]iscord)$"
        "workspace 6 silent, class:^([Ss]potify)$"
        "workspace 7 silent, class:^([Tt]hunderbird)$"
        "workspace 8 silent, class:^([Zz]otero)$"
        "workspace 9 silent, title:^([Tt]ick[Tt]ick).*$"

        # Float volume control (pavucontrol)
        "float, class:^(pavucontrol|org.pulseaudio.pavucontrol)$"
        "size 800 600, class:^(pavucontrol|org.pulseaudio.pavucontrol)$"
        "center, class:^(pavucontrol|org.pulseaudio.pavucontrol)$"

        # Float bluetooth manager (blueman)
        "float, class:^(.blueman-manager-wrapped)$"
        "size 800 600, class:^(.blueman-manager-wrapped)$"
        "center, class:^(.blueman-manager-wrapped)$"

        # Float network manager editor
        "float, class:^(nm-connection-editor)$"
      ];

      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "gammastep"
        "hyprctl setcursor Bibata-Modern-Ice 24"
        "swww-daemon --format xrgb & sleep 0.5 && swww img ${wallpaper}"

        # Autostart Apps (Ensure these are installed in your apps.nix)
        "librewolf"
        "[workspace 4 silent] obsidian"
        "[workspace 5 silent] vesktop"
        "[workspace 6 silent] spotify"
        "[workspace 7 silent] thunderbird"
        "[workspace 8 silent] zotero"
        "[workspace 9 silent] ticktick"
        "[workspace 2 silent] wezterm"
      ];

      input = {
        kb_layout = "pl";
        follow_mouse = 1;

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

      monitor = [
        # Match by exact description (Model + Serial)
        "desc:Iiyama North America PL3467WQ 1214231400456, 3440x1440@165, auto, 1"

        # Fallback for any other monitor you might plug in
        ", preferred, auto, 1"
      ];

      general = {
        "$modifier" = "SUPER";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = [ "linear, 0.0, 0.0, 1.0, 1.0" ];
        animation = [ "workspaces, 1, 5, default, fade" ];
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2;
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      gestures = {
        gesture = [ "3, horizontal, workspace" ];
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
        # --- Application launchers ---
        "$modifier, Q, killactive,"
        "$modifier, RETURN, exec, wezterm"
        "$modifier, SPACE, exec, rofi -show drun"
        "$modifier, D, exec, rofi -show drun"
        "$modifier, E, exec, thunar"
        "$modifier, B, exec, librewolf"
        "$modifier, L, exec, hyprlock"

        # --- Window management ---
        "$modifier, V, togglefloating,"
        "$modifier, F, fullscreen,"
        "$modifier, P, pseudo,"
        "$modifier SHIFT, I, togglesplit,"
        "$modifier SHIFT, F, togglefloating,"
        "$modifier ALT, F, workspaceopt, allfloat"
        "$modifier SHIFT, C, exit,"

        # --- Focus (arrow keys) ---
        "$modifier, left, movefocus, l"
        "$modifier, right, movefocus, r"
        "$modifier, up, movefocus, u"
        "$modifier, down, movefocus, d"

        # --- Focus (vim style) ---
        "$modifier, h, movefocus, l"
        "$modifier, l, movefocus, r"
        "$modifier, k, movefocus, u"
        "$modifier, j, movefocus, d"

        # --- Move Windows (arrow keys) ---
        "$modifier SHIFT, left, movewindow, l"
        "$modifier SHIFT, right, movewindow, r"
        "$modifier SHIFT, up, movewindow, u"
        "$modifier SHIFT, down, movewindow, d"

        # --- Move Windows (vim style) ---
        "$modifier SHIFT, h, movewindow, l"
        "$modifier SHIFT, l, movewindow, r"
        "$modifier SHIFT, k, movewindow, u"
        "$modifier SHIFT, j, movewindow, d"

        # --- Swap Windows (arrow keys) ---
        "$modifier ALT, left, swapwindow, l"
        "$modifier ALT, right, swapwindow, r"
        "$modifier ALT, up, swapwindow, u"
        "$modifier ALT, down, swapwindow, d"

        # --- Swap Windows (vim style) ---
        "$modifier ALT, 43, swapwindow, l" # h
        "$modifier ALT, 46, swapwindow, r" # l
        "$modifier ALT, 45, swapwindow, u" # k
        "$modifier ALT, 44, swapwindow, d" # j

        # --- Workspace switching (1-10) ---
        "$modifier, 1, workspace, 1"
        "$modifier, 2, workspace, 2"
        "$modifier, 3, workspace, 3"
        "$modifier, 4, workspace, 4"
        "$modifier, 5, workspace, 5"
        "$modifier, 6, workspace, 6"
        "$modifier, 7, workspace, 7"
        "$modifier, 8, workspace, 8"
        "$modifier, 9, workspace, 9"
        "$modifier, 0, workspace, 10"

        # --- Move window to workspace ---
        "$modifier SHIFT, 1, movetoworkspace, 1"
        "$modifier SHIFT, 2, movetoworkspace, 2"
        "$modifier SHIFT, 3, movetoworkspace, 3"
        "$modifier SHIFT, 4, movetoworkspace, 4"
        "$modifier SHIFT, 5, movetoworkspace, 5"
        "$modifier SHIFT, 6, movetoworkspace, 6"
        "$modifier SHIFT, 7, movetoworkspace, 7"
        "$modifier SHIFT, 8, movetoworkspace, 8"
        "$modifier SHIFT, 9, movetoworkspace, 9"
        "$modifier SHIFT, 0, movetoworkspace, 10"

        # --- Special workspace (scratchpad) ---
        #"$modifier SHIFT, SPACE, movetoworkspace, special"
        #"$modifier, SPACE, togglespecialworkspace"

        # --- Workspace navigation ---
        "$modifier CTRL, left, movecurrentworkspacetomonitor, l"
        "$modifier CTRL, right, movecurrentworkspacetomonitor, r"
        "$modifier, mouse_down, workspace, e+1"
        "$modifier, mouse_up, workspace, e-1"

        # --- Cycling ---
        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"

        # --- Media and hardware keys ---
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        # Prioritize spotify, then fall back to any other player
        ", XF86AudioPlay, exec, playerctl --player=librewolf,firefox,spotify,%any play-pause"
        ", XF86AudioPause, exec, playerctl --player=librewolf,firefox,spotify,%any play-pause"
        ", XF86AudioNext, exec, playerctl --player=spotify,%any next"
        ", XF86AudioPrev, exec, playerctl --player=spotify,%any previous"

        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"

        "$modifier, F8, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"

        # --- Utilities / screenshots ---
        # NOTE: Using 'XDG_CURRENT_DESKTOP=sway' is a common fix for flameshot on Hyprland
        ", Print, exec, XDG_CURRENT_DESKTOP=sway flameshot gui"
        "$modifier, G, exec, gimp"
        "$modifier, O, exec, obs"
        "$modifier ALT, C, exec, hyprpicker -a"
        "$modifier ALT, M, exec, ncpamixer"

        # --- Custom scripts/launchers ---
        "$modifier, K, exec, qs-keybinds"
        "$modifier CTRL, C, exec, qs-cheatsheets"
        "$modifier SHIFT, K, exec, list-keybinds"
        "$modifier CTRL, S, exec, hyprshot -m output -o $HOME/Pictures/ScreenShots"
        "$modifier SHIFT, S, exec, hyprshot -m window -o $HOME/Pictures/ScreenShots"
        "$modifier ALT, S, exec, hyprshot -m region -o $HOME/Pictures/ScreenShots"
      ];

      bindm = [
        "$modifier, mouse:272, movewindow"
        "$modifier, mouse:273, resizewindow"
      ];
    };
  };

  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
    };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 51.246452;
    longitude = 22.568445;
    temperature = {
      day = 5700;
      night = 3500;
    };
    settings = {
      general.adjustment-method = "wayland";
    };
  };

  services.mpris-proxy.enable = true;
  services.blueman-applet.enable = true;

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        fixed-center = false;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "custom/disk"
          "battery"
          "pulseaudio"
          "clock"
        ];

        tooltip = {
          enabled = true;
          interval = 50;
        };

        "hyprland/window" = {
          max-length = 75;
          separate-outputs = true;
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };

        "clock" = {
          format = "{:%Y-%m-%d | %H:%M }";
          tooltip-format = "<span size='24pt'>{:%Y %B}</span>\n<tt><span size='16pt'>{calendar}</span></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };

        "cpu" = {
          interval = 5;
          format = "{usage}% ";
          tooltip = true;
        };

        "memory" = {
          interval = 5;
          format = "{}% ";
          tooltip-format = "RAM: {used:0.1f} GiB / {total:0.1f} GiB\nSwap: {swapUsed:0.1f} GiB / {swapTotal:0.1f} GiB";
        };

        "custom/disk" = {
          interval = 30;
          exec = "df -B1 / | awk 'NR==2 {printf \"%s (%.1f GiB / %.1f GiB)\", $5, $3/1073741824, $2/1073741824}'";
          format = "{} ";
          tooltip = true;
          tooltip-format = "Mount point: /";
        };

        "disk" = {
          interval = 30;
          format = "{percentage_used}% ({used} / {total}) ";
          path = "/";
          tooltip-format = "{used} used out of {total} on {path}";
        };

        "bluetooth" = {
          format = "{icon}";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-connected = "";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "🔇";
          format-icons = {
            headphone = "";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              "🔈"
              "🔉"
              "🔊"
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = [ "Easy Effects Sink" ];
        };

        "network" = {
          format-ethernet = "{ipaddr} 󰈀";
          format-wifi = "{essid} ({signalStrength}%) {icon}";
          format-disconnected = "Disconnected 󰤮";
          tooltip-format = "{ifname} via {gwaddr}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          on-click = "nm-connection-editor";
        };

        "battery" = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% ({time}) {icon}";
          format-charging = "{capacity}% (Charging) {icon}";
          format-full = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo}";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "💬";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
            ];
          };
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font", "Fira Code", sans-serif;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.9);
        color: #ffffff;
      }

      #workspaces {
        margin: 0;
        padding: 0;
        background: transparent;
      }

      #workspaces button {
        padding: 0 10px;
        margin: 0;
        border-radius: 0;
        background-color: transparent;
        color: #ffffff;
        min-height: 30px;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.2);
        box-shadow: none;
      }

      #workspaces button.active {
        background-color: #64727d;
        border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #disk,
      #custom-disk,
      #memory,
      #temperature,
      #backlight,
      #bluetooth,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        padding: 0 15px 0 10px;
        margin: 0 4px;
        color: #ffffff;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 5px;
      }

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

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #bluetooth {
        color: #7f849c;
      }

      #bluetooth.connected {
        color: #89b4fa;
      }

      #bluetooth.off,
      #bluetooth.disabled {
        color: #f38ba8;
      }
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      width = 350;
      height = 150;
      margin = "20";
      padding = "15";
      border-size = 2;
      border-radius = 8;
      font = "FiraCode Nerd Font 12";
      icons = true;
      max-icon-size = 48;
      background-color = "#1e1e2eff";
      text-color = "#cdd6f4ff";
      border-color = "#89b4faff";
      progress-color = "over #313244ff";
      default-timeout = 5000;
      ignore-timeout = false;
      group-by = "app-name";

      "urgency=low" = {
        border-color = "#a6e3a1ff";
      };

      "urgency=normal" = {
        border-color = "#89b4faff";
      };

      "urgency=critical" = {
        border-color = "#f38ba8ff";
        default-timeout = 0;
      };
    };
  };

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

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
