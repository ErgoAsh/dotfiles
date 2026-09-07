{ ... }: {

  flake.modules.homeManager.idle-laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.hypridle.settings.listener = lib.mkBefore [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
      ];

    };
}
