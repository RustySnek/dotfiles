{ pkgs, ... }:
{
  services.hardware.openrgb.enable = true;
  services.udev.packages = [ pkgs.legacy.openrgb ];
  environment.systemPackages = with pkgs.legacy; [ openrgb-with-all-plugins ];
}
