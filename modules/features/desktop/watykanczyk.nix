{ ... }:
{
  flake.modules.homeManager.watykanczyk =
    { pkgs, ... }:
    let
      watykanczyk = pkgs.writeShellApplication {
        name = "watykanczyk";
        runtimeInputs = [
          pkgs.mpv
          pkgs.playerctl
          pkgs.yt-dlp
        ];
        text = ''
          playerctl --player=spotify pause 2>/dev/null || true

          exec mpv \
            --no-video \
            --start=16 \
            --length=60 \
            --volume=60 \
            --really-quiet \
            --no-terminal \
            --ytdl-format=bestaudio/best \
            -- 'https://youtu.be/1dOt_VcbgyA'
        '';
      };
    in
    {
      systemd.user.services.watykanczyk = {
        Unit.Description = "Execute Watykanczyk at 21:37";

        Service = {
          Type = "oneshot";
          ExecStart = "${watykanczyk}/bin/watykanczyk";
        };
      };

      systemd.user.timers.watykanczyk = {
        Unit.Description = "Execute Watykanczyk at 21:37";

        Timer = {
          OnCalendar = "*-*-* 21:37:00";
          AccuracySec = "1s";
          Persistent = false;
        };

        Install.WantedBy = [ "timers.target" ];
      };
    };
}
