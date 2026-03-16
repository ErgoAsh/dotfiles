{ pkgs, ... }:

{
  # --- Laptop-specific hardware ---
  hardware.enableRedistributableFirmware = true;

  # --- Power management ---
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Disable conflicting power services
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  # Lid switch behavior
  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };
  };

  # --- Printing (extended drivers for laptop) ---
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    foomatic-db
    brlaser
  ];
}
