{ ... }: {

  flake.modules.homeManager.waybar-laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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
          tooltip-format = "{timeTo}";
        };
      };

      programs.waybar.style = lib.mkBefore ''
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
