# Helper functions for Hyprland Lua config generation via Home Manager.
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
  moveWinDir = dir: "hl.dsp.window.move({ direction = ${builtins.toJSON dir} })";
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
    (mkPair "0" 10)
    ++ lib.concatLists (map (i: mkPair (toString i) i) (lib.genList (n: n + 1) 9))
    ++ [
      (bindMod "backslash" (focusWs "11"))
      (bindModOpts "SHIFT + backslash" (moveWinWs "11") { })
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

  moveWinBinds = [
    (bindModOpts "SHIFT + left" (moveWinDir "l") { repeating = true; })
    (bindModOpts "SHIFT + right" (moveWinDir "r") { repeating = true; })
    (bindModOpts "SHIFT + up" (moveWinDir "u") { repeating = true; })
    (bindModOpts "SHIFT + down" (moveWinDir "d") { repeating = true; })
    (bindModOpts "SHIFT + h" (moveWinDir "l") { repeating = true; })
    (bindModOpts "SHIFT + l" (moveWinDir "r") { repeating = true; })
    (bindModOpts "SHIFT + k" (moveWinDir "u") { repeating = true; })
    (bindModOpts "SHIFT + j" (moveWinDir "d") { repeating = true; })
  ];

  swapWinBinds = [
    (bindModOpts "ALT + left" (swapWinDir "l") { repeating = true; })
    (bindModOpts "ALT + right" (swapWinDir "r") { repeating = true; })
    (bindModOpts "ALT + up" (swapWinDir "u") { repeating = true; })
    (bindModOpts "ALT + down" (swapWinDir "d") { repeating = true; })
    (bindModOpts "ALT + h" (swapWinDir "l") { repeating = true; })
    (bindModOpts "ALT + l" (swapWinDir "r") { repeating = true; })
    (bindModOpts "ALT + k" (swapWinDir "u") { repeating = true; })
    (bindModOpts "ALT + j" (swapWinDir "d") { repeating = true; })
  ];
}
