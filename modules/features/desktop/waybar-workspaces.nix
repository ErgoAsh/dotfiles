{ config, ... }:
let
  workspaces = builtins.attrValues config.dotfiles.workspaces;
in
{
  flake.modules.homeManager.waybar-workspaces =
    { pkgs, lib, ... }:
    let
      workspaceNumbers = builtins.sort builtins.lessThan (map (w: w.id) workspaces);
      workspaceIcons = builtins.listToAttrs (
        map (w: {
          name = toString w.id;
          value = w.icon;
        }) workspaces
      );
      workspaceLabels = builtins.listToAttrs (
        map (w: {
          name = toString w.id;
          value = w.label;
        }) workspaces
      );
      workspaceModules = map (ws: "custom/ws${toString ws}") workspaceNumbers;
      workspaceModuleSelectors = lib.concatStringsSep ",\n" (
        map (ws: "#custom-ws${toString ws}") workspaceNumbers
      );
      workspaceModuleHoverSelectors = lib.concatStringsSep ",\n" (
        map (ws: "#custom-ws${toString ws}:hover") workspaceNumbers
      );
      workspaceModuleActiveSelectors = lib.concatStringsSep ",\n" (
        lib.concatMap (ws: [
          "#custom-ws${toString ws}.active"
          "#custom-ws${toString ws}.active-notification"
        ]) workspaceNumbers
      );
      workspaceModuleNotificationSelectors = lib.concatStringsSep ",\n" (
        lib.concatMap (ws: [
          "#custom-ws${toString ws}.notification"
          "#custom-ws${toString ws}.active-notification"
        ]) workspaceNumbers
      );
      notificationWorkspaceByApp = builtins.listToAttrs (
        lib.concatMap (
          w:
          map (app: {
            name = app;
            value = w.id;
          }) w.notificationApps
        ) workspaces
      );
      workspaceState = "$XDG_RUNTIME_DIR/waybar-workspace-state";
      workspaceWatcher = pkgs.writeShellScript "waybar-workspace-watcher" ''
        state="''${XDG_RUNTIME_DIR:?}/waybar-workspace-state"
        nextState="$state.$$"
        events="$state.events.$$"

        cleanup() {
          ${pkgs.coreutils}/bin/rm -f "$nextState" "$events"
        }
        trap cleanup EXIT

        ${pkgs.coreutils}/bin/mkfifo -m 600 "$events"

        ${pkgs.systemd}/bin/busctl --user monitor --json=short \
          --match="type='signal',path='/fr/emersion/Mako',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" \
          | while IFS= read -r _; do
            printf 'notification\n'
          done > "$events" &

        ${pkgs.socat}/bin/socat -u \
          UNIX-CONNECT:"''${XDG_RUNTIME_DIR:?}/hypr/''${HYPRLAND_INSTANCE_SIGNATURE:?}/.socket2.sock" - \
          | while IFS= read -r event; do
            case "$event" in
              workspace* | focusedmon*) printf 'workspace\n' ;;
            esac
          done > "$events" &

        updateState() {
          active="$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j 2>/dev/null | ${pkgs.jq}/bin/jq -r '.id // empty')"
          notifications="$(${pkgs.mako}/bin/makoctl list -j 2>/dev/null | ${pkgs.jq}/bin/jq -r '
            [
              .[]
              | [ .app_name, .desktop_entry ][]
              | select(type == "string")
              | ascii_downcase
            ] as $activeApps
            | ${builtins.toJSON notificationWorkspaceByApp}
            | to_entries
            | map(select(.key as $app | $activeApps | index($app)) | .value)
            | unique[]
            | "notification:\(.)"
          ')"

          printf 'active:%s\n' "$active" > "$nextState"
          if [ -n "$notifications" ]; then
            printf '%s\n' "$notifications" >> "$nextState"
          fi

          if ! ${pkgs.diffutils}/bin/cmp -s "$nextState" "$state"; then
            ${pkgs.coreutils}/bin/mv "$nextState" "$state"
            ${pkgs.procps}/bin/pkill -RTMIN+8 waybar || true
          else
            ${pkgs.coreutils}/bin/rm -f "$nextState"
          fi
        }

        updateState
        while IFS= read -r _; do
          updateState
        done < "$events"
      '';
      workspaceStatus = pkgs.writeShellScript "waybar-workspace-status" ''
        ws="$1"
        icon="$2"
        label="$3"
        state="${workspaceState}"

        active=false
        notification=false
        while IFS=: read -r kind value; do
          if [ "$value" = "$ws" ]; then
            case "$kind" in
              active) active=true ;;
              notification) notification=true ;;
            esac
          fi
        done < "$state" 2>/dev/null

        class=""
        if $active && $notification; then
          class="active-notification"
        elif $active; then
          class="active"
        elif $notification; then
          class="notification"
        fi

        ${pkgs.jq}/bin/jq -cn \
          --arg text "$icon" \
          --arg class "$class" \
          --arg tooltip "Workspace $ws · $label" \
          '{ text: $text, class: $class, tooltip: $tooltip }'
      '';
      workspaceFocus = pkgs.writeShellScript "waybar-workspace-focus" ''
        ws="$1"
        ${pkgs.hyprland}/bin/hyprctl dispatch "hl.dsp.focus({ workspace = $ws })"
      '';
    in
    {
      systemd.user.services.waybar-workspace-watcher = {
        Unit = {
          Description = "Track workspace focus and active application notifications for Waybar";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = workspaceWatcher;
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      programs.waybar.settings.mainBar = {
        modules-left = workspaceModules;
      }
      // lib.genAttrs workspaceModules (
        module:
        let
          ws = lib.removePrefix "custom/ws" module;
        in
        {
          exec = "${workspaceStatus} ${ws} ${lib.escapeShellArg workspaceIcons.${ws}} ${
            lib.escapeShellArg workspaceLabels.${ws}
          }";
          interval = "once";
          signal = 8;
          return-type = "json";
          format = "{}";
          on-click = "${workspaceFocus} ${ws}";
        }
      );

      programs.waybar.style = lib.mkAfter ''
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

        ${workspaceModuleNotificationSelectors} {
          animation-name: blink;
          animation-duration: 0.7s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
      '';
    };
}
