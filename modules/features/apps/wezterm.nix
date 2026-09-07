{ ... }: {

  flake.modules.homeManager.wezterm =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # --- Terminal (WezTerm) ---
      home.sessionVariables.WEZTERM_CONFIG_FILE = "${config.xdg.configHome}/wezterm/wezterm.lua";
      home.file.".wezterm.lua".source =
        config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/wezterm/wezterm.lua";

      programs.wezterm = {
        enable = true;
        extraConfig = ''
          return {
            font = wezterm.font 'FiraCode Nerd Font',
            font_size = 12.0,
            color_scheme = 'Catppuccin Mocha',
            window_background_opacity = 0.72,
            text_background_opacity = 1.0,
            enable_tab_bar = true,
            window_close_confirmation = 'NeverPrompt',
            window_frame = {
              active_titlebar_bg = 'rgba(30, 30, 46, 0.9)',
              inactive_titlebar_bg = 'rgba(30, 30, 46, 0.9)',
            },
            colors = {
              tab_bar = {
                background = 'rgba(30, 30, 46, 0.9)',
                active_tab = {
                  bg_color = 'rgba(49, 50, 68, 0.9)',
                  fg_color = '#cdd6f4',
                },
                inactive_tab = {
                  bg_color = 'rgba(24, 24, 37, 0.9)',
                  fg_color = '#a6adc8',
                },
                inactive_tab_hover = {
                  bg_color = 'rgba(49, 50, 68, 0.9)',
                  fg_color = '#cdd6f4',
                },
                new_tab = {
                  bg_color = 'rgba(30, 30, 46, 0.9)',
                  fg_color = '#a6adc8',
                },
                new_tab_hover = {
                  bg_color = 'rgba(49, 50, 68, 0.9)',
                  fg_color = '#cdd6f4',
                },
              },
            },
            keys = {
              { key = 'Enter', mods = 'SHIFT', action = wezterm.action { SendString = '\x1b\r' } },
            },
          }
        '';
      };

    };
}
