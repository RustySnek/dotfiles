{ ... }:
{

  services.udev.extraRules =
    ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4007", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4010", MODE="0666"
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3633", MODE="0666"
    ''
    + builtins.readFile ./openrgb_udev;
}
