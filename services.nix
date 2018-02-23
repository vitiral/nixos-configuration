# Services, including the window manager and associated packages

{ config, pkgs, hardware, ... }:
let
  setxkbmapPackages = with pkgs.xorg; {
    inherit xinput xset setxkbmap xmodmap; };

  i3Packages = with pkgs; {
    inherit i3-gaps i3status i3lock-fancy;
    inherit (xorg) xrandr xbacklight xset;
    inherit (pythonPackages) alot py3status;
  };

  xorgPackages = with pkgs; [
    networkmanagerapplet
    networkmanager_openconnect
    openconnect
    openssl
    scrot
    xcape
    xsel
  ];

in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; 
    ( builtins.attrValues (
      i3Packages // 
      setxkbmapPackages 
    ) )
    ++ xorgPackages;

  # ---- SERVICES ----
  services = {
    nixosManual.showManual = true;
    openssh.enable = true; 	# Enable the OpenSSH daemon.
    printing.enable = true; 	# Enable CUPS to print documents.
    dbus.enable = true;
    upower.enable = true;
    acpid.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      # Enable touchpad support.
      libinput.enable = true;

      windowManager = {
        default = "i3";
        i3 = {
          enable = true;
        };
      };

      displayManager = {
        lightdm.enable = true;
        sessionCommands = ''
          setxkbmap -option 'caps:ctrl_modifier
          # FIXME: this would be nice
          # # run ssh-agent
          # killall ssh-agent
          # ssh-agent
          # ssh-add ~/.ssh/id_rsa
          # ssh-add ~/.ssh/id_dsa
          # exec i3 -V >> ~/.i3/logs 2>&1
        '';
      };
      
      # xkbOptions = "eurosign:e";
      # xkbOptions = "ctrl:nocaps";
    };
  };

  systemd.user.services."xcape" = {
    enable = true;
    description = "xcape to use CTRL as ESC when pressed alone";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape";
  };
}
