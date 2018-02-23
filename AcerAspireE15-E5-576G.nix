# Edit this configuration file to define what should be installed on # your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hardware, ... }:
let
  terminalApps = with pkgs; [
    # fzf
    gitAndTools.gitFull
    gitAndTools.hub
    htop
    iotop
    jq
    libnotify
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

  # ---- BASIC CONFIG ----

  fonts.fonts = with pkgs; [
    nerdfonts
  ];


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; 
    terminalApps;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;

  # ---- NETWORKING ----
  networking.hostName = "garrett-laptop"; # Define your hostname.
}
