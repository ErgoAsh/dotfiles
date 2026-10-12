{ lib, config, ... }:
let
  ws = config.dotfiles.workspaces;
in
{
  options.dotfiles.hyprlandLua = lib.mkOption {
    type = lib.types.raw;
    internal = true;
  };
  config.dotfiles.hyprlandLua = # Helper functions for Hyprland Lua config generation via Home Manager.
    lib:
    let
      inherit (lib.generators) mkLuaInline;
    in
    rec {
      inherit mkLuaInline;

      bindMod = key: lua: {
        _args = [
          (mkLuaInline ''mod .. " + ${key}"'')
          (mkLuaInline lua)
        ];
      };

      bindModOpts = key: lua: opts: {
        _args = [
          (mkLuaInline ''mod .. " + ${key}"'')
          (mkLuaInline lua)
        ]
        ++ lib.optional (opts != { }) opts;
      };

      bindKey = key: lua: {
        _args = [
          key
          (mkLuaInline lua)
        ];
      };

      bindKeyOpts = key: lua: opts: {
        _args = [
          key
          (mkLuaInline lua)
        ]
        ++ lib.optional (opts != { }) opts;
      };

      bindMouseMod = key: lua: {
        _args = [
          (mkLuaInline ''mod .. " + ${key}"'')
          (mkLuaInline lua)
          { mouse = true; }
        ];
      };

      focusDir = dir: "hl.dsp.focus({ direction = ${builtins.toJSON dir} })";
      moveWinMonitor = monitor: "hl.dsp.window.move({ monitor = ${builtins.toJSON monitor} })";
      swapWinDir = dir: "hl.dsp.window.swap({ direction = ${builtins.toJSON dir} })";
      focusWs = ws: "hl.dsp.focus({ workspace = ${ws} })";
      moveWinWs = ws: "hl.dsp.window.move({ workspace = ${ws} })";
      execCmd = cmd: "hl.dsp.exec_cmd(${builtins.toJSON cmd})";

      workspaceBinds =
        let
          mkPair = key: ws: [
            (bindMod key (focusWs (toString ws)))
            (bindModOpts "SHIFT + ${key}" (moveWinWs (toString ws)) { })
          ];
        in
        lib.concatMap (w: mkPair w.key w.id) [
          ws.study
          ws.browser
          ws.terminal
          ws.editors
          ws.music
          ws.chat
          ws.notes
          ws.references
          ws.mail
          ws.tasks
          ws.audio
          ws.chatgpt
        ];

      focusBinds =
        let
          mkRepeat = key: dir: bindModOpts key (focusDir dir) { repeating = true; };
        in
        [
          (mkRepeat "left" "l")
          (mkRepeat "right" "r")
          (mkRepeat "up" "u")
          (mkRepeat "down" "d")
          (mkRepeat "h" "l")
          (mkRepeat "l" "r")
          (mkRepeat "k" "u")
          (mkRepeat "j" "d")
        ];

      swapWinBinds = [
        (bindModOpts "SHIFT + left" (swapWinDir "l") { repeating = true; })
        (bindModOpts "SHIFT + right" (swapWinDir "r") { repeating = true; })
        (bindModOpts "SHIFT + up" (swapWinDir "u") { repeating = true; })
        (bindModOpts "SHIFT + down" (swapWinDir "d") { repeating = true; })
        (bindModOpts "SHIFT + h" (swapWinDir "l") { repeating = true; })
        (bindModOpts "SHIFT + l" (swapWinDir "r") { repeating = true; })
        (bindModOpts "SHIFT + k" (swapWinDir "u") { repeating = true; })
        (bindModOpts "SHIFT + j" (swapWinDir "d") { repeating = true; })
      ];

      moveWinMonitorBinds = [
        (bindModOpts "CTRL + SHIFT + left" (moveWinMonitor "l") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + right" (moveWinMonitor "r") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + up" (moveWinMonitor "u") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + down" (moveWinMonitor "d") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + h" (moveWinMonitor "l") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + l" (moveWinMonitor "r") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + k" (moveWinMonitor "u") { repeating = true; })
        (bindModOpts "CTRL + SHIFT + j" (moveWinMonitor "d") { repeating = true; })
      ];
    };
}
