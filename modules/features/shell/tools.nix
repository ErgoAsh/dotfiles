{ ... }: {

  flake.modules.homeManager.shell-tools =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fzf.enable = true;
      programs.bat.enable = true;
      programs.eza.enable = true;

      home.packages = with pkgs; [
        psmisc
        xclip
        ffmpeg
        tree
        duf
        gh
        ripgrep
        fd
        btop
        ncdu
        unzip
        zip
        libqalculate
        hyperfine
        devenv
        devbox
        fastfetch
        yubioath-flutter
        yubikey-manager
        hunspell
        hunspellDicts.en_US
        hunspellDicts.pl_PL

        tio
        usbutils
        usbview

        gcc
        cmake
        gnumake
        gdb
        perf
        valgrind
        nixfmt
        nodejs_22
        pnpm
        python3Packages.pip

        code-cursor
        cursor-cli
      ];

    };
}
