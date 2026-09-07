{ ... }: {

  flake.modules.homeManager.mime =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "librewolf.desktop" ];
          "x-scheme-handler/http" = [ "librewolf.desktop" ];
          "x-scheme-handler/https" = [ "librewolf.desktop" ];
          "inode/directory" = [ "thunar.desktop" ];
          "application/x-zerosize" = [ "org.xfce.mousepad.desktop" ];
          "text/plain" = [ "org.xfce.mousepad.desktop" ];
          "text/markdown" = [ "org.xfce.mousepad.desktop" ];
          "text/x-typst" = [ "org.xfce.mousepad.desktop" ];
          "text/x-log" = [ "org.xfce.mousepad.desktop" ];
          "application/json" = [ "org.xfce.mousepad.desktop" ];
          "application/xml" = [ "org.xfce.mousepad.desktop" ];
          "application/x-typst" = [ "org.xfce.mousepad.desktop" ];
        };
      };

    };
}
