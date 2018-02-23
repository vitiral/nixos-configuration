# Basic configuration
{ config, pkgs, hardware, ... }:
let
  systemApps = with pkgs; [
    # pulseaudio
    acpi
    lm_sensors
  ];

  desktopApps = with pkgs; [
    chromium
    firefox
    libreoffice
    vlc
  ];
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    desktopApps ++ systemApps;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Denver";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  networking.networkmanager.enable = true;  # Enables wireless support via network manager
  # networking.wireless.enable = true;       # Enables wireless support via wpa_supplicant.
  # networking.firewall.enable = true;
  # networking.firewall.autoLoadConntrackHelpers = true;

  # Open ports in the firewall.
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers."garrett" = {
    isNormalUser = true;
    group = "users";
    extraGroups = [
      "wheel" "systemd-journal"
      "disk" "networkmanager"
      "audio" "video"
    ];
    # createHome = true;
    uid = 1000;
    # home = /home/garrett;
    shell = /run/current-system/sw/bin/zsh;
  };

  # users.mutableUsers = false;  # cool, but need to use hashedPassword option
  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
