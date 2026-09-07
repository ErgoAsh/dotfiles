{ ... }:
{
  flake.modules.homeManager.thunderbird =
    { ... }:
    {
      programs.thunderbird = {
        enable = true;
        profiles.default = {
          isDefault = true;
          settings = {
            "calendar.timezone.local" = "Europe/Warsaw";
            "calendar.timezone.useSystemTimezone" = false;
            "intl.regional_prefs.use_os_locales" = true;
            "mail.threadpane.listview" = 1;
            "mail.uifontsize" = 14;
          };
        };
      };
    };
}
