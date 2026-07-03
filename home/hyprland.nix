{
  pkgs,
  lib,
  ...
}:

let
  wallpaper = ../wallpapers/wallhaven-lyz3d2.png;
  applyWallpaper = pkgs.writeShellScript "hyprland-apply-wallpaper" ''
    ${pkgs.procps}/bin/pgrep -x awww-daemon >/dev/null || ${pkgs.awww}/bin/awww-daemon --format xrgb &
    sleep 1
    ${pkgs.awww}/bin/awww img ${wallpaper} --transition-type none
  '';
  h = import ./hyprland-lua.nix lib;
  inherit (h)
    bindMod
    bindModOpts
    bindKey
    bindKeyOpts
    bindMouseMod
    execCmd
    focusBinds
    moveWinBinds
    swapWinBinds
    workspaceBinds
    mkLuaInline
    ;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      mod = {
        _var = "SUPER";
      };

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = {
            colors = [
              "rgba(33ccffee)"
              "rgba(00ff99ee)"
            ];
            angle = 45;
          };
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 5;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            ignore_opacity = true;
          };
        };

        animations = {
          enabled = true;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        cursor = {
          sync_gsettings_theme = true;
          no_hardware_cursors = 2;
          enable_hyprcursor = false;
          warp_on_change_workspace = 2;
          no_warps = true;
        };

        input = {
          kb_layout = "pl";
          follow_mouse = 1;
        };
      };

      env = [
        {
          _args = [
            "LV2_PATH"
            "/etc/profiles/per-user/ergoash/lib/lv2:/run/current-system/sw/lib/lv2"
          ];
        }
        {
          _args = [
            "VST_PATH"
            "/etc/profiles/per-user/ergoash/lib/vst:/run/current-system/sw/lib/vst"
          ];
        }
      ];

      bind = [
        # Application launchers
        (bindMod "Q" "hl.dsp.window.close()")
        (bindMod "RETURN" (execCmd "wezterm"))
        (bindMod "SPACE" (execCmd "rofi -show drun"))
        (bindMod "D" (execCmd "rofi -show drun"))
        (bindMod "E" (execCmd "thunar"))
        (bindMod "B" (execCmd "librewolf"))
        (bindMod "L" (execCmd "hyprlock"))

        # Window management
        (bindMod "V" "hl.dsp.window.float()")
        (bindMod "F" "hl.dsp.window.fullscreen()")
        (bindMod "P" "hl.dsp.window.pseudo()")
        (bindModOpts "SHIFT + I" "hl.dsp.global(\"layoutmsg togglesplit\")" { })
        (bindModOpts "SHIFT + F" "hl.dsp.window.float()" { })
        (bindModOpts "ALT + F" "hl.dsp.global(\"workspaceopt allfloat\")" { })
        (bindModOpts "SHIFT + C" "hl.dsp.exit()" { })

        # Workspace navigation
        (bindModOpts "CTRL + left" "hl.dsp.workspace.move({ monitor = \"l\" })" { })
        (bindModOpts "CTRL + right" "hl.dsp.workspace.move({ monitor = \"r\" })" { })
        (bindModOpts "mouse_down" "hl.dsp.focus({ workspace = \"e+1\" })" { })
        (bindModOpts "mouse_up" "hl.dsp.focus({ workspace = \"e-1\" })" { })

        # Cycling windows on Alt+Tab
        {
          _args = [
            "ALT + Tab"
            (mkLuaInline ''
              function()
                hl.dispatch(hl.dsp.window.cycle_next())
                hl.dispatch(hl.dsp.window.bring_to_top())
              end
            '')
          ];
        }

        # Media and hardware keys
        (bindKey "XF86AudioRaiseVolume" (execCmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
        (bindKey "XF86AudioLowerVolume" (execCmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
        (bindKey "XF86AudioMute" (execCmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
        (bindKey "XF86AudioPlay" (execCmd "playerctl --player=librewolf,firefox,spotify,%any play-pause"))
        (bindKey "XF86AudioPause" (execCmd "playerctl --player=librewolf,firefox,spotify,%any play-pause"))
        (bindKey "XF86AudioNext" (execCmd "playerctl --player=spotify,%any next"))
        (bindKey "XF86AudioPrev" (execCmd "playerctl --player=spotify,%any previous"))
        (bindMod "F8" (execCmd "${pkgs.playerctl}/bin/playerctl -p spotify play-pause"))

        # Utilities / screenshots
        (bindKey "Print" (execCmd "flameshot gui"))
        (bindMod "G" (execCmd "gimp"))
        (bindMod "O" (execCmd "obs"))
        (bindModOpts "ALT + C" (execCmd "hyprpicker -a") { })
        (bindModOpts "ALT + M" (execCmd "ncpamixer") { })

        # Custom scripts / launchers
        (bindMod "K" (execCmd "qs-keybinds"))
        (bindModOpts "CTRL + C" (execCmd "qs-cheatsheets") { })
        (bindModOpts "SHIFT + K" (execCmd "list-keybinds") { })
        (bindModOpts "CTRL + S" (execCmd "hyprshot -m output -o $HOME/Pictures/ScreenShots") { })
        (bindModOpts "SHIFT + S" (execCmd "hyprshot -m window -o $HOME/Pictures/ScreenShots") { })
        (bindModOpts "ALT + S" (execCmd "hyprshot -m region -o $HOME/Pictures/ScreenShots") { })
      ]
      ++ focusBinds
      ++ moveWinBinds
      ++ swapWinBinds
      ++ workspaceBinds
      ++ [
        (bindMouseMod "mouse:272" "hl.dsp.window.drag()")
        (bindMouseMod "mouse:273" "hl.dsp.window.resize()")
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("gammastep")
                hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
                hl.exec_cmd("awww-daemon --format xrgb")
                hl.exec_cmd(${builtins.toJSON "${applyWallpaper}"})
                hl.exec_cmd("anki", { workspace = "10 silent" })
                hl.exec_cmd("wezterm", { workspace = "2 silent" })
                hl.exec_cmd("spotify", { workspace = "4 silent" })
                hl.exec_cmd("vesktop", { workspace = "5 silent" })
                hl.exec_cmd("obsidian", { workspace = "6 silent" })
                hl.exec_cmd("zotero", { workspace = "7 silent" })
                hl.exec_cmd("thunderbird", { workspace = "8 silent" })
                hl.exec_cmd("ticktick", { workspace = "9 silent" })
                hl.exec_cmd("librewolf", { workspace = "1 silent" })
                hl.timer(function()
                  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
                end, { timeout = 3000, type = "oneshot" })
                hl.timer(function()
                  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
                end, { timeout = 10000, type = "oneshot" })
              end
            '')
          ];
        }
      ];
    };

    extraConfig = ''
      hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "linear", style = "fade" })

      local window_rules = {
        { match = { class = "^[Aa]nki$" }, workspace = "10 silent" },
        { match = { class = "^[Ll]ibre[Ww]olf$" }, workspace = "1 silent" },
        { match = { class = "^[Rr]io$" }, workspace = "2 silent" },
        { match = { class = "^jetbrains%-.*$" }, workspace = "3 silent" },
        { match = { class = "^(code%-url%-handler|code%-oss|Code)$" }, workspace = "3 silent" },
        { match = { class = "^[Ss]potify$" }, workspace = "4 silent" },
        { match = { class = "^([Vv]esktop|[Dd]iscord)$" }, workspace = "5 silent" },
        { match = { class = "^[Oo]bsidian$" }, workspace = "6 silent" },
        { match = { class = "^[Zz]otero$" }, workspace = "7 silent" },
        { match = { class = "^[Tt]hunderbird$" }, workspace = "8 silent" },
        { match = { title = "^[Tt]ick[Tt]ick.*$" }, workspace = "9 silent" },
        { match = { class = "^[Aa]rdour.*$" }, workspace = "11 silent" },
        { match = { class = "^steam$" }, float = true },
        { match = { class = "^steam$", title = "^$" }, no_shadow = true },
        { match = { class = "^steam$", title = "^Steam$" }, float = false },
        { match = { class = "^steam$", title = "^Big Picture$" }, float = false },
        { match = { class = "^librewolf$", title = "^Extension:.*$" }, float = true, size = "450 650", center = true },
        { match = { title = "Bitwarden Password Manager" }, float = true },
        { match = { class = "^[Tt]hunar$" }, float = true, center = true, size = "900 600" },
        { match = { class = "^(org%.xfce%.mousepad|[Mm]ousepad)$" }, float = true, center = true, size = "900 600" },
        { match = { class = "^(pavucontrol|org%.pulseaudio%.pavucontrol)$" }, float = true, size = "800 600", center = true },
        { match = { class = "^%.blueman%-manager%-wrapped$" }, float = true, size = "800 600", center = true },
        { match = { class = "^nm%-connection%-editor$" }, float = true },
      }

      for _, rule in ipairs(window_rules) do
        hl.window_rule(rule)
      end

      -- nwg-displays writes hyprlang monitor= lines; apply them after static rules
      local function load_monitors_conf()
        local path = (os.getenv("HOME") or "") .. "/.config/hypr/monitors.conf"
        local file = io.open(path, "r")
        if not file then
          return
        end
        for line in file:lines() do
          local spec = line:match("^monitor%s*=%s*(.+)")
          if spec and not spec:match("^%s*#") then
            hl.dispatch(hl.dsp.global("monitor " .. spec))
          end
        end
        file:close()
      end

      hl.on("hyprland.start", function()
        load_monitors_conf()
      end)
    '';
  };
}
