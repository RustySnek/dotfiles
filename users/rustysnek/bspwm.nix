{
  lib,
  pkgs,
  ...
}: {
  xsession.enable = true;
  services.picom = {
    enable = true;
    settings = {
      shadow = true;
      shadow-radius = 7;
      shadow-offset-x = -7;
      shadow-offset-y = -7;
      shadow-exclude = [
        "name = 'Notification'"
        "class_g = 'Conky'"
        "class_g ?= 'Notify-osd'"
        "class_g = 'Cairo-clock'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      fading = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
      inactive-opacity = 0.95;
      frame-opacity = 0.9;
      inactive-opacity-override = false;
      focus-exclude = ["class_g = 'Cairo-clock'"];
      corner-radius = 0;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
      blur-kern = "3x3box";
      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      backend = "xrender";
      vsync = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      unredir-if-possible = false;
      detect-transient = true;
      glx-no-stencil = true;
      use-damage = true;
      log-level = "warn";
      wintypes = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.75;
          focus = true;
          full-shadow = false;
        };
        dock = {
          shadow = false;
          clip-shadow-above = true;
        };
        dnd = {shadow = false;};
        popup_menu = {opacity = 0.8;};
        dropdown_menu = {opacity = 0.8;};
      };
    };
  };
  services.sxhkd.enable = true;
  services.sxhkd.keybindings = {
    "super + Return" = "kitty ~";
    "Print" = "gscreenshot -sc";
    "super + @space" = "~/.config/rofi/launchers/type-5/launcher.sh";
    "super + alt + l" = "i3lock --nofork -c '#4ff28f' -f -e";
    "ctrl + super + {q,r}" = "bspc {quit, wm -r}";
    "super + x" = "bspc node -{c,k}";
    "alt + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating, fullscreen}";
    "alt + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
    "alt + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
    "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{11,12,13,14,15,16,17,18,19,20}'";
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
      xrandr --output DP-4 --primary --refresh 144.0 --mode 1920x1080 --output HDMI-0 --right-of DP-4 --refresh 60.0 --mode 1920x1080 &
      ~/.config/polybar-themes/setup.sh &
      ''
    ];
    extraConfig = builtins.concatStringsSep "\n" [
      ''
                  xss-lock --transfer-sleep-lock -- i3lock --nofork -c "#5f0f9f" -f -e&
                  flameshot &
                  xwallpaper --maximize ~/Pictures/ml2.png & 
                ~/.config/polybar/launch.sh --forest &
        LV_BRANCH='release-1.3/neovim-0.9' ~/Projects/dotfiles/users/rustysnek/lunarvim/install.sh &

      ''
    ];
    package = pkgs.bspwm;
    monitors = {
      DP-4 = [
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
      HDMI-0 = [
        "XI"
        "XII"
        "XIII"
        "XIV"
        "XV"
        "XVI"
        "XVII"
        "XVIII"
        "XIX"
        "XX"
      ];
    };
  };
}
