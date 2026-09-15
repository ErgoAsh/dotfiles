{ config, ... }:
let
  leftMonitor = "Iiyama North America PL1906 11013A9702441";
  leftWorkspaceModules = map (w: "custom/ws${toString w.id}") (
    builtins.sort (a: b: a.id < b.id) (
      builtins.filter (w: w.laptopMonitor == "desc:${leftMonitor}") (
        builtins.attrValues config.dotfiles.workspaces
      )
    )
  );
in
{

  flake.modules.homeManager.waybar-laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      keyboardToggle = pkgs.writeShellScript "toggle-screen-keyboard" ''
        ${pkgs.systemd}/bin/systemctl --user start wvkbd.service
        ${pkgs.procps}/bin/pkill -RTMIN -x wvkbd-mobintl
      '';
      nvmeTemperature = pkgs.writeShellScript "waybar-nvme-temperature" ''
        for hwmon in /sys/class/hwmon/hwmon*; do
          [ "$(${pkgs.coreutils}/bin/cat "$hwmon/name" 2>/dev/null)" = "nvme" ] || continue
          [ -r "$hwmon/temp1_input" ] || continue

          millidegrees="$(${pkgs.coreutils}/bin/cat "$hwmon/temp1_input")"
          degrees=$((millidegrees / 1000))
          class=""
          if [ "$degrees" -ge 75 ]; then
            class="critical"
          fi

          ${pkgs.jq}/bin/jq -cn \
            --arg text "$degrees°C 󰋊" \
            --arg tooltip "NVMe: $degrees°C" \
            --arg class "$class" \
            '{ text: $text, tooltip: $tooltip, class: $class }'
          exit 0
        done

        ${pkgs.jq}/bin/jq -cn \
          '{ text: "N/A 󰋊", tooltip: "Nie znaleziono czujnika temperatury NVMe", class: "unavailable" }'
      '';
      mainBar = config.programs.waybar.settings.mainBar;
      leftWorkspaceSettings = lib.genAttrs leftWorkspaceModules (module: mainBar.${module});
    in
    {
      programs.waybar.settings.mainBar = {
        output = [
          "!${leftMonitor}"
          "*"
        ];

        modules-right = lib.mkForce [
          "custom/keyboard"
          "tray"
          "group/hardware"
          "custom/disk"
          "battery"
          "pulseaudio"
          "clock"
        ];

        "custom/keyboard" = {
          format = "⌨";
          tooltip-format = "Show or hide the on-screen keyboard";
          on-click = keyboardToggle;
        };

        "group/hardware" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 300;
            transition-left-to-right = false;
          };
          modules = [
            "cpu"
            "temperature#cpu"
            "temperature#gpu"
            "custom/temperature-nvme"
            "memory"
          ];
        };

        "temperature#cpu" = lib.mkForce {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C ";
          tooltip-format = "CPU: {temperatureC}°C";
        };

        "temperature#gpu" = lib.mkForce {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:08.1/0000:03:00.0/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°C ";
          tooltip-format = "GPU: {temperatureC}°C";
        };

        "custom/temperature-nvme" = {
          exec = nvmeTemperature;
          interval = 10;
          return-type = "json";
          format = "{}";
        };

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
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "Estimated time: {time}\nBattery health: {health}%\nCharge cycles: {cycles}";
        };
      };

      programs.waybar.settings.leftBar = {
        name = "compact";
        output = leftMonitor;
        layer = "top";
        position = "top";
        exclusive = true;
        passthrough = false;
        height = 33;
        fixed-center = false;
        modules-left = leftWorkspaceModules;
        modules-center = [ "hyprland/window" ];
        modules-right = [ "clock" ];
        tooltip = mainBar.tooltip;
        "hyprland/window" = mainBar."hyprland/window" // {
          max-length = 45;
        };
        clock = mainBar.clock // {
          format = "{:%H:%M}";
        };
      }
      // leftWorkspaceSettings;

      programs.waybar.style = lib.mkBefore ''
        #custom-keyboard {
          min-width: 24px;
          padding: 0 8px;
          font-size: 17px;
        }

        #custom-temperature-nvme {
          padding: 0 15px 0 10px;
          margin: 0 4px;
          color: #ffffff;
          background-color: rgba(255, 255, 255, 0.1);
          border-radius: 5px;
        }

        #custom-temperature-nvme.critical {
          background-color: #f53c3c;
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
      '';

    };
}
