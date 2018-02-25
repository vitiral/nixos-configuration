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
    nix
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

  
  videoPkgs = with pkgs; [
    pciutils # `lspci` to list hardware
    glxinfo
  ];
  
  rustPkgs = with pkgs; [
    rustup
    carnix
  ];
in {
  environment.systemPackages = with pkgs;
    terminalApps
    # ++ rustPkgs
    ++ videoPkgs;

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  programs.bash.enableCompletion = true;

  nix.package = pkgs.nixUnstable;
}
