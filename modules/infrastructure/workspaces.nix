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
      icon = "󰈹";
      laptopMonitor = "desc:Lenovo Group Limited E22-20 VY036074";
      laptopDefault = true;
    };
    terminal = {
      id = 2;
      key = "2";
      label = "Terminal";
      icon = "";
      laptopMonitor = "desc:BOE 0x0A2A";
      laptopDefault = true;
    };
    editors = {
      id = 3;
      key = "3";
      label = "IDEs";
      icon = "";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    music = {
      id = 4;
      key = "4";
      label = "Spotify";
      icon = "󰓇";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    chat = {
      id = 5;
      key = "5";
      label = "Discord";
      icon = "󰭹";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    notes = {
      id = 6;
      key = "6";
      label = "Obsidian";
      icon = "󰈙";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    references = {
      id = 7;
      key = "7";
      label = "Zotero";
      icon = "󰂺";
      laptopMonitor = "desc:Lenovo Group Limited E22-20 VY036074";
    };
    mail = {
      id = 8;
      key = "8";
      label = "Thunderbird";
      icon = "󰇰";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    tasks = {
      id = 9;
      key = "9";
      label = "TickTick";
      icon = "󰄬";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
      laptopDefault = true;
    };
    study = {
      id = 10;
      key = "0";
      label = "Anki";
      icon = "󰗚";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
    audio = {
      id = 11;
      key = "minus";
      label = "Ardour";
      icon = "󰎆";
      laptopMonitor = "desc:BOE 0x0A2A";
    };
    chatgpt = {
      id = 12;
      key = "backslash";
      label = "ChatGPT";
      icon = "󰚩";
      laptopMonitor = "desc:Iiyama North America PL1906 11013A9702441";
    };
  };
  config.flake.lib.workspaces = config.dotfiles.workspaces;
}
