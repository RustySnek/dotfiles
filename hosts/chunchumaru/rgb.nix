{ pkgs, ... }:
{
  services.hardware.openrgb.enable = true;
  services.udev.packages = [ pkgs.openrgb ];
  environment.systemPackages = with pkgs; [ openrgb-with-all-plugins ];
}
