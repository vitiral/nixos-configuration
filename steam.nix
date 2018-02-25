# Steam Configuration
{ config, pkgs, hardware, ... }: {
  hardware.opengl.driSupport32Bit = true;
  environment.systemPackages = with pkgs; [
    steam
  ];
}
