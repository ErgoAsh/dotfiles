{ ... }: {

  flake.modules.homeManager.flameshot =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # --- Screenshot tool (flameshot) ---
      services.flameshot = {
        enable = true;
        settings = {
          General = {
            useGrimAdapter = true;
            disabledGrimWarning = true;
          };
        };
      };

    };
}
