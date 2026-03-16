{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      n = {
        description = "Support nnn quit and change directory";
        body = ''
          if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
              echo "nnn is already running"
              return
          end

          if test -n "$XDG_CONFIG_HOME"
              set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
          else
              set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
          end

          command nnn $argv -A -r -U

          if test -e $NNN_TMPFILE
              source $NNN_TMPFILE
              rm $NNN_TMPFILE
          end
        '';
      };
    };

    shellInit = ''
      set -xg PAGER "bat --wrap=never --style=numbers,changes --theme gruvbox-dark"
      set -xg MANPAGER "sh -c 'col -bx | bat --language=man --style=numbers,rule'"
      set -xg MANROFFOPT "-c"
      set -xg MANWIDTH (math $COLUMNS - 6)

      set -xg NNN_FIFO '/tmp/nnn.fifo'
      set -xg NNN_PLUG 'o:fzopen;p:mocq;d:diffs;t:nmount;v:preview-tui;c:!convert "$nnn" png:- | xclip -sel clipboard -t image/png*'
      set -xg NNN_PAGER 'bat --wrap=never --style=changes'
      set -xg NNN_BATTHEME gruvbox-dark
    '';

    interactiveShellInit = ''
      fish_vi_key_bindings

      set fish_cursor_default block blink
      set fish_cursor_insert line blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual block

      if test -e ~/.cache/wal/sequences
        cat ~/.cache/wal/sequences
      end
      if test -e ~/.cache/wal/colors-tty.sh
        bass source ~/.cache/wal/colors-tty.sh
      end

      function fish_greeting
        fastfetch
      end
    '';

    functions.fish_user_key_bindings = ''
      fzf_configure_bindings --git_status=\cs --git_log=\cg --history=\ch --variables=\e\cv --processes=\cp --directory=\cf

      bind --erase \cv
      bind -M insert --erase \cv
      bind -M default --erase \cv
    '';

    shellAliases = {
      dotfiles = "git --git-dir=$HOME/dotfiles --work-tree=$HOME";
      dot = "git --git-dir=$HOME/dotfiles --work-tree=$HOME";
      ll = "eza -ahl --no-user --time-style=long-iso --group-directories-first";
      paths = "echo $PATH | tr -s ':' '\n'";
      fonts = "fc-list : family | sort";
    };

    shellAbbrs = {
      cat = "bat";
      grep = "rg";
      find = "fd";
      df = "duf";
      mixer = "ncpamixer";
      calc = "qalc";
      c = "qalc";
      vi = "hx";
      neofetch = "fastfetch";
      rebuild = "sudo nixos-rebuild switch --flake .#$hostname";
    };

    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    plugins = {
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.9";
          sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
        })
        + "/plugins";
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = [
      pkgs.tinymist
      pkgs.typstyle
      pkgs.nixd
      pkgs.nixfmt-rfc-style
    ];

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        mouse = true;
      };
    };

    languages = {
      language = [
        {
          name = "typst";
          auto-format = true;
          formatter = {
            command = "typstyle";
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
          language-servers = [ "nixd" ];
        }
      ];
      language-server.nixd = {
        command = "nixd";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      credential.helper = "${pkgs.gh}/bin/gh auth git-credential";
      pull.rebase = false;
      user = {
        name = "ErgoAsh";
        email = "3192123+ErgoAsh@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
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
  ];
}
