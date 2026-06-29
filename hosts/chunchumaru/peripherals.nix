{ pkgs, ... }:
{
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "rustysnek" ];

  services.hardware.openrgb.enable = true;
  services.udev.packages = [ pkgs.unstable.openrgb ];
  environment.systemPackages = with pkgs.unstable; [ openrgb-with-all-plugins ];

  services.udev.extraRules =
    ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4007", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4010", MODE="0666"
    ''
    + builtins.readFile ./openrgb_udev;
}
