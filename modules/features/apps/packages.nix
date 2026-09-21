{ ... }: {

  flake.modules.homeManager.apps =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = with pkgs; [
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
        libreoffice-fresh
        zotero

        openrgb-with-all-plugins

        mission-center
        qdirstat
        gnome-disk-utility
        file-roller
        xarchiver
        mousepad

        # --- Music ---
        ardour
        qpwgraph
        sfizz-ui

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

        # --- Audio ---
        ncpamixer

        # --- Browser extensions (native connectors) ---
        tridactyl-native
      ];

    };
}
