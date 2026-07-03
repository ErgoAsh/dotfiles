{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

let
  opencv-qt =
    (pkgs.opencv4.override {
      enableGStreamer = true;
      enableTbb = true;
      enableUnfree = true;
      enableContrib = true;
    }).overrideAttrs
      (oldAttrs: {
        buildInputs =
          (oldAttrs.buildInputs or [ ])
          ++ (with pkgs; [
            qt5.qtbase
            qt5.qtwayland
          ]);
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
          pkgs.qt5.wrapQtAppsHook
        ];
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DWITH_QT=ON"
        ];
      });

  h = import ./hyprland-lua.nix lib;
  inherit (h)
    bindMod
    bindModOpts
    bindKey
    execCmd
    ;
in
{
  home.packages = with pkgs; [
    brightnessctl
    texstudio
    texliveFull
    corefonts # Microsoft fonts including Times New Roman
    (python3.withPackages (ps: with ps; [ pygments ])) # For LaTeX minted package
    opencv-qt # OpenCV with Qt GUI support (custom build from source)
    qt5.qtwayland # Qt Wayland platform plugin
    libsForQt5.qt5.qtbase # Qt platform plugins
  ];

  # Set Qt plugin path for applications using OpenCV with Qt
  home.sessionVariables = {
    QT_PLUGIN_PATH = "${pkgs.qt5.qtbase}/lib/qt-${pkgs.qt5.qtbase.version}/plugins";
    QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt5.qtbase}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms";
  };

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        {
          output = "desc:BOE 0x0A2A";
          mode = "1920x1200@60";
          position = "0x0";
          scale = 1;
        }
        {
          output = "desc:Synaptics Inc Non-PnP 0x00BC614E";
          mode = "1920x1080@60";
          position = "-1920x0";
          scale = 1;
        }
        {
          output = "desc:LG Electronics L1740P 0x00016B3F";
          mode = "1280x1024@60";
          position = "-3200x0";
          scale = 1;
        }
      ];

      workspace_rule = [
        {
          workspace = "3";
          monitor = "desc:LG Electronics L1740P 0x00016B3F";
        }
        {
          workspace = "4";
          monitor = "desc:LG Electronics L1740P 0x00016B3F";
        }
        {
          workspace = "8";
          monitor = "desc:LG Electronics L1740P 0x00016B3F";
        }
        {
          workspace = "9";
          monitor = "desc:LG Electronics L1740P 0x00016B3F";
          default = true;
        }
        {
          workspace = "10";
          monitor = "desc:LG Electronics L1740P 0x00016B3F";
        }
        {
          workspace = "1";
          monitor = "desc:Synaptics Inc Non-PnP 0x00BC614E";
          default = true;
        }
        {
          workspace = "2";
          monitor = "desc:BOE 0x0A2A";
          default = true;
        }
        {
          workspace = "5";
          monitor = "desc:BOE 0x0A2A";
        }
        {
          workspace = "6";
          monitor = "desc:BOE 0x0A2A";
        }
        {
          workspace = "7";
          monitor = "desc:BOE 0x0A2A";
        }
      ];

      config = {
        input = {
          touchpad = {
            natural_scroll = true;
            tap_to_click = true;
            disable_while_typing = true;
          };

          touchdevice = {
            output = "eDP-1";
            transform = 0;
          };
        };

        gestures = {
          workspace_swipe_distance = 500;
          workspace_swipe_invert = true;
          workspace_swipe_min_speed_to_force = 30;
          workspace_swipe_cancel_ratio = 0.5;
          workspace_swipe_create_new = true;
          workspace_swipe_forever = true;
        };

      };

      bind = [
        (bindKey "XF86MonBrightnessDown" (execCmd "brightnessctl set 5%-"))
        (bindKey "XF86MonBrightnessUp" (execCmd "brightnessctl set +5%"))
        (bindMod "Y" (execCmd "wezterm -e yazi"))
        (bindModOpts "SHIFT + W" (execCmd "qs-wallpapers-apply") { })
        (bindModOpts "SHIFT + N" (execCmd "swaync-client -rs") { })
        (bindModOpts "CTRL + D" (execCmd "dock") { })
        (bindMod "TAB" (execCmd "qs ipc -c overview call overview toggle"))
        (bindModOpts "SHIFT + T" (execCmd "pypr toggle term") { })
      ];
    };

  };

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

  programs.waybar.style = ''
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

  services.hypridle.settings.listener = [
    {
      timeout = 300;
      on-timeout = "brightnessctl -s set 10";
      on-resume = "brightnessctl -r";
    }
  ];
}
