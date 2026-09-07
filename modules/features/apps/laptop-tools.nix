{ ... }: {

  flake.modules.homeManager.laptop-tools =
    {
      config,
      pkgs,
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

    };
}
