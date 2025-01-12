# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./../default/configuration.nix
      ./hardware-configuration.nix
    ];

  boot.initrd.luks.devices."luks-fc997cd4-eb0f-4dfe-8193-17698bee3567".device = "/dev/disk/by-uuid/fc997cd4-eb0f-4dfe-8193-17698bee3567";

  # Enable networking
  networking.hostName = "server-wyse";

  system.stateVersion = "24.11";
}
