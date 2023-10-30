{
  lib,
  pkgs,
  ...
}: {
  xsession.enable = true;

  services.sxhkd.enable = true;
  xsession.windowManager.bspwm = {
    enable = true;
    package = pkgs.bspwm;
    monitors = {
      eDP-1 = [
        "I"
        "II"
        "III"
        "IV"
        "V"
        "VI"
        "VII"
        "VIII"
        "IX"
        "X"
      ];
    };
  };
}
