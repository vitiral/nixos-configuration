# Edit this configuration file to define what should be installed on # your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hardware, ... }: {
  # ---- HARDWARE ----
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./basic.nix
      ./services.nix
      ./terminal.nix
      ./video.nix
    ];

  networking.hostName = "garrett-laptop";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Use TLP for power management
  powerManagement.cpuFreqGovernor = pkgs.lib.mkForce null;
  services.tlp.enable = true;
  
  # Misc Configuration
  # environment.systemPackages = with pkgs; [ 
  #   blueman # bluetooth applet
  # ];
  # hardware.bluetooth.enable = true;
  hardware.bluetooth.enable = false;
}
