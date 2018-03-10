{ config, pkgs, hardware, ... }:
let
  terminalApps = with pkgs; [
    feh
    # fzf
    gitAndTools.gitFull
    gitAndTools.hub
    htop
    iotop
    jq
    libnotify
    mosh
    nix
    nix-index
    nix-repl
    nix-zsh-completions
    (import ./novault)
    oh-my-zsh
    psmisc
    pythonFull
    python2Full
    ripgrep
    rxvt_unicode_with-plugins
    tmux
    tree
    vim_configurable
    unzip
    wget
    zsh
  ];

  videoPkgs = with pkgs; [
    glxinfo
    lshw     # `lshw -c video` to list video drivers
    pciutils # `lspci` to list hardware
  ];
  
  rustPkgs = with pkgs; [
    pkgconfig
    binutils
    gcc
    gnumake
    rustup
    rustc
    cargo
    # TODO(broken): cargo-edit
    carnix
  ];
in {
  environment.systemPackages = with pkgs;
    terminalApps
    ++ rustPkgs
    ++ videoPkgs;
  
  environment.variables = {
    EDITOR = "vim";
    PKG_CONFIG_PATH = with pkgs; [
      "${openssl.dev}/lib/pkgconfig"
    ];
    LIBRARY_PATH = with pkgs; [
      "${xorg.libX11}/lib"
      "${xorg.libXtst}/lib"
    ];
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  programs.bash.enableCompletion = true;

  nix.package = pkgs.nixUnstable;
}
