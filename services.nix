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
    scrot     # screen shot
    xcape     # override capslock
    xsel      # override capslock
    pamixer   # audio control
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
      xkbOptions = "caps:ctrl_modifier";

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
      };
    };
  };

  # TODO: this works except the icon is always a red error icon
  # systemd.user.services."network-manager-applet" = {
  #   enable = true;
  #   description = "Start the network manager applet";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.Type = "forking";
  #   serviceConfig.Restart = "always";
  #   serviceConfig.RestartSec = 2;
  #   serviceConfig.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  #   environment = {
  #      # this was a failed _attempt_ to fix the icon issue to no avail
  #      XDG_DATA_DIRS = "${pkgs.networkmanagerapplet}/bin/nm-applet/share";
  #   };
  # };

  systemd.user.services."xcape" = {
    enable = true;
    description = "xcape to use CTRL as ESC when pressed alone";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape -e 'Caps_Lock=Escape'";
  };

  # TODO: this doesn't seem to work :(
  # systemd.user.services."keycode-menu-super" = {
  #   enable = true;
  #   description = "Remap the Menu key to Super_R for i3";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.Type = "forking";
  #   serviceConfig.Restart = "no";
  #   serviceConfig.ExecStart = ''
  #     /run/current-system/sw/bin/xmodmap -e 'keycode 135 = Super_R' \
  #       && /run/current-system/sw/bin/xset -r 137
  #   '';
  # };
}
