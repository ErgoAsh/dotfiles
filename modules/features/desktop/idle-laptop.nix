{ config, ... }:
let
  flakeConfig = config;
in
{

  flake.modules.homeManager.idle-laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      h = flakeConfig.dotfiles.hyprlandLua lib;
      inherit (h) bindKeyOpts execCmd;
      lidClose = pkgs.writeShellScript "lid-close" ''
        monitors="$(${pkgs.hyprland}/bin/hyprctl monitors -j)" || exit 1
        if ${pkgs.jq}/bin/jq -e 'any(.[]; .name != "eDP-1")' <<< "$monitors" >/dev/null; then
          exit 0
        fi

        ${pkgs.systemd}/bin/loginctl lock-session
        ${pkgs.hyprland}/bin/hyprctl dispatch dpms off
        ${pkgs.systemd}/bin/systemctl --user restart lid-suspend.timer
      '';
      lidOpen = pkgs.writeShellScript "lid-open" ''
        ${pkgs.systemd}/bin/systemctl --user stop lid-suspend.timer
        ${pkgs.hyprland}/bin/hyprctl dispatch dpms on
      '';
    in
    {
      services.hypridle.settings.listener = lib.mkBefore [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
      ];

      systemd.user.services = {
        lid-switch-inhibitor = {
          Unit = {
            Description = "Let Hyprland handle the laptop lid switch";
            PartOf = [ "hyprland-session.target" ];
            After = [ "hyprland-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-lid-switch --who=Hyprland --why='Delayed lid suspend' --mode=block ${pkgs.coreutils}/bin/sleep infinity";
          };
          Install.WantedBy = [ "hyprland-session.target" ];
        };

        lid-suspend = {
          Unit.Description = "Suspend and schedule hibernation after the lid closes";
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
          };
        };
      };

      systemd.user.timers.lid-suspend = {
        Unit = {
          Description = "Suspend 15 minutes after the lid closes";
          PartOf = [ "hyprland-session.target" ];
        };
        Timer = {
          OnActiveSec = "15min";
          AccuracySec = "1s";
          Unit = "lid-suspend.service";
        };
      };

      wayland.windowManager.hyprland.settings.bind = lib.mkAfter [
        (bindKeyOpts "switch:on:Lid Switch" (execCmd lidClose) { locked = true; })
        (bindKeyOpts "switch:off:Lid Switch" (execCmd lidOpen) { locked = true; })
      ];

    };
}
