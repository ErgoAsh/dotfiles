{ ... }: {

  flake.modules.homeManager.notifications =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.mako = {
        enable = true;
        settings = {
          anchor = "top-right";
          width = 350;
          height = 150;
          margin = "20";
          padding = "15";
          border-size = 2;
          border-radius = 8;
          font = "FiraCode Nerd Font 12";
          icons = true;
          max-icon-size = 48;
          background-color = "#1e1e2eff";
          text-color = "#cdd6f4ff";
          border-color = "#89b4faff";
          progress-color = "over #313244ff";
          default-timeout = 5000;
          ignore-timeout = false;
          group-by = "app-name";

          "urgency=low" = {
            border-color = "#a6e3a1ff";
          };

          "urgency=normal" = {
            border-color = "#89b4faff";
          };

          "urgency=critical" = {
            border-color = "#f38ba8ff";
            default-timeout = 0;
          };
        };
      };

    };
}
