{ lib, config, ... }: {
  options.dotfiles.workspaces = lib.mkOption {
    description = "Shared workspace IDs, keys, labels, icons and laptop monitor placement.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          id = lib.mkOption { type = lib.types.ints.positive; };
          key = lib.mkOption { type = lib.types.str; };
          label = lib.mkOption { type = lib.types.str; };
          icon = lib.mkOption { type = lib.types.str; };
          notificationApps = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
          laptopMonitor = lib.mkOption { type = lib.types.str; };
          laptopDefault = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      }
    );
  };
  config.dotfiles.workspaces = {
    browser = {
      id = 1;
      key = "1";
      label = "LibreWolf";
      notificationApps = [ "librewolf" ];
      icon = "󰈹";
      laptopMonitor = "desc:Lenovo Group Limited E22-20 VY036074";
      laptopDefault = true;
    };
    terminal = {
      id = 2;
      key = "2";
      label = "Terminal";
      notificationApps = [
        "org.wezfurlong.wezterm"
        "wezterm"
      ];
      icon = "";
      laptopMonitor = "desc:BOE 0x0A2A";
      laptopDefault = true;
    };
    editors = {
      id = 3;
      key = "3";
      label = "IDEs";
      notificationApps = [
        "codex"
        "code"
        "visual studio code"
      ];
      icon = "";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    music = {
      id = 4;
      key = "4";
      label = "Spotify";
      notificationApps = [ "spotify" ];
      icon = "󰓇";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    chat = {
      id = 5;
      key = "5";
      label = "Discord";
      notificationApps = [
        "discord"
        "vesktop"
      ];
      icon = "󰭹";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    notes = {
      id = 6;
      key = "6";
      label = "Obsidian";
      notificationApps = [ "obsidian" ];
      icon = "󰈙";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    references = {
      id = 7;
      key = "7";
      label = "Zotero";
      notificationApps = [ "zotero" ];
      icon = "󰂺";
      laptopMonitor = "desc:Lenovo Group Limited E22-20 VY036074";
    };
    mail = {
      id = 8;
      key = "8";
      label = "Thunderbird";
      notificationApps = [ "thunderbird" ];
      icon = "󰇰";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    tasks = {
      id = 9;
      key = "9";
      label = "TickTick";
      notificationApps = [ "ticktick" ];
      icon = "󰄬";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
      laptopDefault = true;
    };
    study = {
      id = 10;
      key = "0";
      label = "Anki";
      notificationApps = [ "anki" ];
      icon = "󰗚";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    audio = {
      id = 11;
      key = "minus";
      label = "Ardour";
      notificationApps = [ "ardour" ];
      icon = "󰎆";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    chatgpt = {
      id = 12;
      key = "backslash";
      label = "ChatGPT";
      notificationApps = [ "chatgpt" ];
      icon = "󰚩";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
  };
  config.flake.lib.workspaces = config.dotfiles.workspaces;
}
