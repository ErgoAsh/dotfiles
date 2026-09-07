{ ... }: {

  flake.modules.homeManager.vscode =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # --- Code editor (VSCode) ---
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        profiles.default.userSettings = {
          "editor.fontFamily" = "'FiraCode Nerd Font', 'Symbols Nerd Font', monospace";
          "editor.fontLigatures" = true;
        };
      };

    };
}
