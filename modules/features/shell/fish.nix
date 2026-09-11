{ ... }: {
  flake.modules.nixos.fish = {
    programs.fish.enable = true;
  };
  flake.modules.homeManager.fish =
    {
      config,
      pkgs,
      lib,
      ...
    }:
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
          dot = "cd ~/dotfiles";
          dots = "cd ~/dotfiles";
          ll = "eza -ahl --no-user --time-style=long-iso --group-directories-first";
          paths = "echo $PATH | tr -s ':' '\n'";
          fonts = "fc-list : family | sort";
          disk-usage = "ncdu -x /";
          codex = "npx @openai/codex@latest";
        };

        shellAbbrs = {
          grep = "rg";
          find = "fd";
          df = "duf";
          mixer = "ncpamixer";
          calc = "qalc";
          c = "qalc";
          vi = "hx";
          neofetch = "fastfetch";
          check-config = "nix flake check --no-build --no-write-lock-file path:$HOME/dotfiles";
          build-config = "nix build --no-link --no-write-lock-file path:$HOME/dotfiles#nixosConfigurations.$hostname.config.system.build.toplevel";
          rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#$hostname";
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

    };
}
