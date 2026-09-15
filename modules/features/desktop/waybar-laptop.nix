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
