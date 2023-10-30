{
  lib,
  pkgs,
  ...
}: {
  xsession.enable = true;
  services.picom = {
    enable = true;
  };
  services.sxhkd.enable = true;
  services.sxhkd.keybindings = {
    "super + Return" = "kitty";
    "Print" = "flameshot gui";
    "super + @space" = "~/.config/rofi/launchers/type-5/launcher.sh";
    "super + Up" = "brillo -A 5";
    "super + Down" = "brillo -U 5";
    "super + alt + l" = "i3lock --nofork -c '#1f1f1f' -f -e";
    "ctrl + super + {q,r}" = "bspc {quit, wm -r}";
    "super + x" = "bspc node -{c,k}";
    "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating, fullscreen}";
    "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
    "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
  };
  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      border_width = 2;
      gapless_monocle = true;
      borderless_monocle = true;
      active_border_color = "#1c2e5d";
      window_gap = 0.5;
      split_ratio = 0.52;
    };
    extraConfigEarly = builtins.concatStringsSep "\n" [
      ''
        ~/.config/polybar-themes/setup.sh &
      ''
    ];
    extraConfig = builtins.concatStringsSep "\n" [
      ''
          xss-lock --transfer-sleep-lock -- i3lock --nofork -c "#1f1f1f" -f -e&
          flameshot &
          xwallpaper --center ~/Pictures/hw.jpg &
        ~/.config/polybar/launch.sh --forest &
      ''
    ];
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
