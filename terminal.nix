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
  environment.systemPackages = with pkgs;
    terminalApps;

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  programs.bash.enableCompletion = true;

}
