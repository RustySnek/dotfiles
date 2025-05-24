{ pkgs, ... }:
{
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
      fade-in-step = 3.0e-2;
      fade-out-step = 3.0e-2;
      frame-opacity = 0.9;
      focus-exclude = [ "class_g = 'Cairo-clock'" ];
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
      vsync = false;
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
        dnd = {
          shadow = false;
        };
        popup_menu = {
          opacity = 0.8;
        };
        dropdown_menu = {
          opacity = 0.8;
        };
      };
    };
  };
  services.sxhkd.enable = true;
  services.sxhkd.keybindings = {
    "super + Return" = "kitty ~";
    "super + b" = "~/Projects/VM/toggle.sh";
    "Print" = "gscreenshot -sc";
    "super + @space" = "~/.config/rofi/launchers/type-5/launcher.sh";
    "super + alt + l" = "i3lock --nofork -f -e -t -i /home/rustysnek/Pictures/lock.png -c '#4ff28f'";
    "ctrl + super + {q,r}" = "bspc {quit, wm -r}";
    "super + x" = "bspc node -{c,k}";
    "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating, fullscreen}";
    "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
    "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
    "alt + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{11,12,13,14,15,16,17,18,19,20}'";

  };
  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      border_width = 0.5;
      gapless_monocle = true;
      borderless_monocle = true;
      active_border_color = "#63B7F7";
      focused_border_color = "#F3C7FF";
      window_gap = 0.5;
      split_ratio = 0.5;
    };
    extraConfigEarly = builtins.concatStringsSep "\n" [
      ''
        ~/.config/polybar-themes/setup.sh &
        openrgb --profile ~/Projects/dotfiles/users/rustysnek/main.orp &
        easyeffects -l main &
        xrandr --output DisplayPort-0 --primary --auto --left-of HDMI-A-0 --rate 144 --auto && xrandr --output HDMI-A-0 --mode 1920x1080 --rate 144.00
      ''
    ];
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        xss-lock --transfer-sleep-lock -- i3lock --nofork -t -i /home/rustysnek/Pictures/lock.png -c "#5f0f9f" -f -e&
        xwallpaper --maximize ~/Pictures/pape.jpg & 
        ~/.config/polybar/launch.sh --forest
      ''
    ];
    package = pkgs.bspwm;
    monitors = {

      DisplayPort-0 = [
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
      HDMI-A-0 = [
        "XI"
        "XII"
        "XIII"
        "XIV"
        "XV"
        "XVI"
        "XVII"
      ];
    };
  };
}
