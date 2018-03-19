{ config, pkgs, hardware, ... }:
let
  terminalApps = with pkgs; [
    alacritty
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
    (import ./novault.pkg)
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
  
  # https://github.com/koute/cargo-web/issues/51
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
    emscripten
  ];

  nodePkgs = with pkgs; [
    nodejs
    npm2nix
  ];
in {
  environment.systemPackages = with pkgs;
    terminalApps
    ++ rustPkgs
    ++ nodePkgs
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

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      nerdfonts
      powerline-fonts
      unifont
      source-code-pro
    ];
  };

  programs.bash.enableCompletion = true;

  nix.package = pkgs.nixUnstable;
}
