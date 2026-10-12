{ ... }: {

  flake.modules.homeManager.apps =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      packetTracerInstaller = ../../../CiscoPacketTracer_901_Ubuntu_64bit.deb;
    in
    {
      home.packages =
        with pkgs;
        [
          # --- Productivity & office ---
          obsidian
          vesktop
          anki
          (lib.lowPrio pcloud)
          xournalpp
          hardinfo2
          geany
          ticktick
          teams-for-linux
          webex
          libreoffice-fresh
          zotero

          openrgb-with-all-plugins

          mission-center
          qdirstat
          gnome-disk-utility
          file-roller
          xarchiver
          mousepad
          gimp
          inkscape

          # --- Media ---
          spotify
          vlc
          imv
          zathura

          # --- Development & tools ---
          jetbrains.pycharm
          jetbrains.clion
          positron-bin
          tinymist
          R
          jre25_minimal
          savvycan
          can-utils
          simulide

          # --- Audio ---
          ncpamixer

          # --- Browser extensions (native connectors) ---
          tridactyl-native
        ]
        ++ lib.optionals (builtins.pathExists packetTracerInstaller) [
          (pkgs.cisco-packet-tracer_9.override {
            requireFile = _: packetTracerInstaller;
          })
        ];

    };
}
