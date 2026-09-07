{ ... }: {

  flake.modules.homeManager.midi-idle =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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

    };
}
