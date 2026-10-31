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
      packetTracerInstallerAvailable =
        builtins.pathExists packetTracerInstaller
        &&
          builtins.hashFile "sha256" packetTracerInstaller
          != "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
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
          gthumb
          zathura

          # --- Development & tools ---
          jetbrains.pycharm
          jetbrains.clion
          tinymist
          jre25_minimal
          savvycan
          can-utils
          simulide
          oh-my-git

          # --- Audio ---
          ncpamixer

          # --- Browser extensions (native connectors) ---
          tridactyl-native
        ]
        ++ lib.optionals packetTracerInstallerAvailable [
          (pkgs.cisco-packet-tracer_9.override {
            requireFile = _: packetTracerInstaller;
          })
        ];

    };
}
