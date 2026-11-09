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
        package = pkgs.vscode.overrideAttrs (old: {
          postPatch =
            lib.replaceStrings
              [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
              [ "resources/app/node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
              old.postPatch;
        });
        profiles.default.userSettings = {
          "editor.fontFamily" = "'FiraCode Nerd Font', 'Symbols Nerd Font', monospace";
          "editor.fontLigatures" = true;
        };
      };

    };
}
