{ ... }: {
  flake.modules.nixos.thunar = { pkgs, ... }: {
    # --- File Management Services ---
    # Thunar is here because it often requires system services (GVFS/Tumbler)
    # to work correctly for mounting drives.
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true; # Mount, Trash, and other file system services
    services.tumbler.enable = true; # Thumbnail support for images

  };
  flake.modules.homeManager.thunar =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # Thunar: right-click → copy full path (Wayland clipboard)
      xdg.configFile."Thunar/uca.xml".text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
          <action>
            <icon>edit-copy</icon>
            <name>_Kopiuj ścieżkę</name>
            <submenu></submenu>
            <unique-id>1749230000000000-1</unique-id>
            <command>wl-copy -- %f</command>
            <description>Skopiuj pełną ścieżkę do schowka</description>
            <range></range>
            <patterns>*</patterns>
            <directories/>
            <audio-files/>
            <image-files/>
            <other-files/>
            <text-files/>
            <video-files/>
          </action>
        </actions>
      '';

    };
}
