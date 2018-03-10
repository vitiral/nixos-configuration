# Configuration if a video card is present
{ config, pkgs, hardware, ... }: {
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
}
