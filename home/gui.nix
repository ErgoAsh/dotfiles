{
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}:

let
  # Waybar 0.15.0 in nixpkgs uses legacy hyprctl dispatch; broken with Hyprland 0.55 Lua.
  waybar = (pkgs.waybar.override { cavaSupport = false; }).overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "05945748dccce28bf96d26d8f64a9e69a8dd49ba";
      hash = "sha256-51R3mIt8cLNvh/X5qe9vOqeJCj0U9KRyemVE5y+OhiU=";
    };
    version = "0.15.0";
  });
  workspaceNumbers = lib.range 1 11;
  workspaceIcons = {
    "1" = "󰈹";
    "2" = "";
    "3" = "";
    "4" = "󰓇";
    "5" = "󰭹";
    "6" = "󰈙";
    "7" = "󰂺";
    "8" = "󰇰";
    "9" = "󰄬";
    "10" = "󰗚";
    "11" = "󰎆";
  };
  workspaceModules = map (ws: "custom/ws${toString ws}") workspaceNumbers;
  workspaceModuleSelectors = lib.concatStringsSep ",\n" (
    map (ws: "#custom-ws${toString ws}") workspaceNumbers
  );
  workspaceModuleHoverSelectors = lib.concatStringsSep ",\n" (
    map (ws: "#custom-ws${toString ws}:hover") workspaceNumbers
  );
  workspaceModuleActiveSelectors = lib.concatStringsSep ",\n" (
    map (ws: "#custom-ws${toString ws}.active") workspaceNumbers
  );
  workspaceStatus = pkgs.writeShellScript "waybar-workspace-status" ''
    ws="$1"
    icon="$2"
    active="$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.id')"

    class=""
    if [ "$active" = "$ws" ]; then
      class="active"
    fi

    printf '{"text":"%s","class":"%s","tooltip":"Workspace %s"}\n' "$icon" "$class" "$ws"
  '';
  workspaceFocus = pkgs.writeShellScript "waybar-workspace-focus" ''
    ws="$1"
    ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.focus({ workspace = $ws })"
    ${pkgs.procps}/bin/pkill -RTMIN+8 waybar || true
  '';
in
{
  imports = [ ./hyprland.nix ];
  home.packages = with pkgs; [
    waybar
    awww
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
    playerctl # Media player control
    nerd-fonts.fira-code
    nerd-fonts.symbols-only

    alsa-utils
    nwg-displays
  ];

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
    package = waybar;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        height = 33;
        fixed-center = false;

        modules-left = workspaceModules;
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "temperature#cpu"
          "temperature#gpu"
          "cpu"
          "memory"
          "custom/disk"
          "pulseaudio"
          "clock"
        ];

        tooltip = {
          enabled = true;
          interval = 25;
        };

        "hyprland/window" = {
          max-length = 75;
          separate-outputs = true;
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };

        "temperature#cpu" = {
          hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C ";
          tooltip-format = "CPU Temp";
        };

        "temperature#gpu" = {
          hwmon-path = "/sys/class/hwmon/hwmon0/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C ";
          tooltip-format = "GPU Temp";
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
          exec = pkgs.writeShellScript "disk-usage" ''
            read -r _ _ used avail _ _ <<< $(df -B1 / | tail -1)
            used_gb=$(awk "BEGIN {printf \"%.1f\", $used/1073741824}")
            total_gb=$(awk "BEGIN {printf \"%.1f\", ($used+$avail)/1073741824}")
            free_gb=$(awk "BEGIN {printf \"%.1f\", $avail/1073741824}")
            percent=$(awk "BEGIN {printf \"%.0f\", 100*$used/($used+$avail)}")
            echo "{\"text\":\"$percent% ($used_gb GiB / $total_gb GiB)\",\"tooltip\":\"Free: $free_gb GiB\"}"
          '';
          return-type = "json";
          format = "{} 󰋊";
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
          format-muted = "󰖁";
          format-icons = {
            headphone = "";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
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

      }
      // lib.genAttrs workspaceModules (
        module:
        let
          ws = lib.removePrefix "custom/ws" module;
        in
        {
          exec = "${workspaceStatus} ${ws} ${lib.escapeShellArg workspaceIcons.${ws}}";
          interval = 1;
          signal = 8;
          return-type = "json";
          format = "{}";
          on-click = "${workspaceFocus} ${ws}";
        }
      );
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font", "Symbols Nerd Font", sans-serif;
        font-size: 13px;
        font-weight: 400;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.9);
        color: #ffffff;
      }

      ${workspaceModuleSelectors} {
        padding: 0 10px;
        margin: 0;
        border-radius: 0;
        background-color: transparent;
        color: #ffffff;
        min-height: 30px;
        min-width: 14px;
        border-bottom: 3px solid transparent;
      }

      ${workspaceModuleHoverSelectors} {
        background: rgba(255, 255, 255, 0.2);
        box-shadow: none;
      }

      ${workspaceModuleActiveSelectors} {
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
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  systemd.user.services.midi-idle-inhibit = {
    Unit = {
      Description = "Inhibit hypridle on MIDI input";
      After = [ "pipewire.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "midi-idle-inhibit" ''
        COOKIE_FILE="/tmp/midi-inhibit-cookie"
        TIME_FILE="/tmp/midi-inhibit-time"

        inhibit() {
          [ -f "$COOKIE_FILE" ] && return
          cookie=$(dbus-send --session \
            --dest=org.freedesktop.ScreenSaver \
            --type=method_call --print-reply \
            /org/freedesktop/ScreenSaver \
            org.freedesktop.ScreenSaver.Inhibit \
            string:"midi-idle-inhibit" string:"MIDI keyboard active" \
            2>/dev/null | awk '/uint32/ {print $2}')
          echo "$cookie" > "$COOKIE_FILE"
          echo "inhibited (cookie: $cookie)"
        }

        uninhibit() {
          [ -f "$COOKIE_FILE" ] || return
          cookie=$(cat "$COOKIE_FILE")
          dbus-send --session \
            --dest=org.freedesktop.ScreenSaver \
            --type=method_call \
            /org/freedesktop/ScreenSaver \
            org.freedesktop.ScreenSaver.UnInhibit \
            uint32:"$cookie" 2>/dev/null
          rm -f "$COOKIE_FILE"
          echo "uninhibited"
        }

        cleanup() { uninhibit; rm -f "$TIME_FILE"; kill 0; }
        trap cleanup EXIT

        watchdog() {
          while true; do
            sleep 5
            [ -f "$TIME_FILE" ] || continue
            last=$(cat "$TIME_FILE")
            now=$(date +%s)
            if [ -f "$COOKIE_FILE" ] && [ $(( now - last )) -gt 15 ]; then
              uninhibit
            fi
          done
        }
        watchdog &

        aseqdump -p "40:0" | while IFS= read -r line; do
          echo "$line" | grep -qE "Note|Control|Pitch" || continue
          date +%s > "$TIME_FILE"
          inhibit
        done
      '';
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
