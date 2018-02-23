# Edit this configuration file to define what should be installed on # your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hardware, ... }:
let
  terminalApps = with pkgs; [
    # pulseaudio
    acpi
    # fzf
    gitAndTools.gitFull
    gitAndTools.hub
    htop
    iotop
    jq
    libnotify
    lm_sensors
    nix-index
    nix-repl
    nix-zsh-completions
    oh-my-zsh
    psmisc
    pythonFull
    python2Full
    rxvt_unicode_with-plugins
    tmux
    vim_configurable
    unzip
    wget
    zsh
  ];

  desktopApps = with pkgs; [
    chromium
    firefox
    libreoffice
    vlc
  ];

in {
  # ---- HARDWARE ----
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./services.nix
    ];
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Denver";
  
  # ---- BASIC CONFIG ----

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; 
    terminalApps
    ++ desktopApps;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # ---- NETWORKING ----
  networking.hostName = "garrett-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Enables wireless support via network manager
  # networking.firewall.enable = true;
  # networking.firewall.autoLoadConntrackHelpers = true;
  # networking.nameservers = ["10.116.133.40" "10.117.30.40"];
  # networking.domain = "pw.solidfire.net";

  # Open ports in the firewall.
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers."garrett" = {
    isNormalUser = true;
    group="users";
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
