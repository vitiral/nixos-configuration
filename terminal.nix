{ config, pkgs, hardware, ... }:
let
  terminalApps = with pkgs; [
    alacritty
    cmus
    direnv
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
    nvi  # berkley vi editor
    # osquery
    psmisc
    ripgrep
    rxvt_unicode_with-plugins
    tokei
    tmux
    tree
    vim_configurable
    unzip
    wget
    zsh
  ];

  pythonPkgs = with pkgs; [
    # Dev / CI
    mypy
    python36Packages.virtualenv
    python36Packages.virtualenvwrapper
    python36Packages.pylint
    python36Packages.autopep8

    # python2
    (python27.withPackages(ps: with ps; [
      ipython
      pip
      pyyaml 
      pytoml
      requests 
      six
      ipdb
    ]))

    # python3
    (python36.withPackages(ps: with ps; [
      ipython
      pip
      pyyaml 
      pytoml
      requests 
      six
      ipdb

      # Scientific / Numerical
      numpy
      pandas
      scipy
      sqlalchemy
    ]))
  ];

  videoPkgs = with pkgs; [
    glxinfo
    lshw     # `lshw -c video` to list video drivers
    pciutils # `lspci` to list hardware
  ];

  webPkgs = with pkgs; [
    geckodriver
    chromedriver
    emscripten
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
    ++ pythonPkgs
    ++ webPkgs
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
    TERMINAL = "alacritty";
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
