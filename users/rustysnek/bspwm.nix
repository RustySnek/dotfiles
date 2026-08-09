{ pkgs, ... }:
{
  xsession.enable = true;
  services.picom.enable = true;
  # The home-manager picom module always emits old-style rule options
  # (shadow-exclude, blur-background-exclude, wintypes, opacity-rule, ...) as
  # mkDefaults. picom's new `rules` system ignores ALL of those the moment
  # `rules` is present, emitting a warning per option. There is no way to make
  # the module drop them, so the whole config file is overridden here and every
  # rule-like option is migrated into the unified `rules` list. The systemd
  # service loads this exact file via `--config`.
  # (`open` = spawn zoom, `geometry` = resize/move morph, also fires on bspwm
  #  desktop switch since mainline picom has no workspace concept.)
  xdg.configFile."picom/picom.conf".text = pkgs.lib.mkForce ''
    backend = "glx";
    vsync = true;

    fading = true;
    fade-in-step = 0.06;
    fade-out-step = 0.06;

    shadow = true;
    shadow-radius = 7;
    shadow-offset-x = -7;
    shadow-offset-y = -7;
    shadow-opacity = 0.75;

    corner-radius = 0;

    blur-method = "dual_kawase";
    blur-strength = 1;
    blur-background = true;

    frame-opacity = 0.9;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    detect-transient = true;
    unredir-if-possible = false;
    use-damage = true;
    log-level = "warn";

    rules = (
      { match = "name = 'Notification'";         shadow = false; },
      { match = "class_g = 'Conky'";             shadow = false; },
      { match = "class_g ?= 'Notify-osd'";       shadow = false; },
      { match = "class_g = 'Cairo-clock'";       shadow = false; },
      { match = "window_type = 'desktop'";       shadow = false; blur-background = false; },
      { match = "window_type = 'dock'";          shadow = false; blur-background = false; clip-shadow-above = true; },
      { match = "_GTK_FRAME_EXTENTS@";           shadow = false; blur-background = false; },
      { match = "window_type = 'tooltip'";       opacity = 0.75; full-shadow = false; },
      { match = "window_type = 'dnd'";           shadow = false; },
      { match = "window_type = 'popup_menu'";    opacity = 0.8; },
      { match = "window_type = 'dropdown_menu'"; opacity = 0.8; },
      # flameshot selection overlay: skip the spawn animation (no-op open)
      {
        match = "class_g = 'flameshot'";
        animations = ( { triggers = [ "open" ]; opacity = { duration = 0.01; start = 1; end = 1; }; } );
      }
    );

    animations = (
      { triggers = [ "open" ];     preset = "appear";          scale = 0.2; duration = 0.15; },
      { triggers = [ "geometry" ]; preset = "geometry-change";              duration = 0.15; }
    );
  '';
  services.sxhkd.enable = true;
  services.sxhkd.keybindings = {
    "super + Return" = "kitty ~";
    "super + b" = "~/Projects/VM/toggle.sh";
    "Print" = "flameshot gui";
    "super + @space" = "~/.config/rofi/launchers/type-5/launcher.sh";
    "super + alt + l" = "i3lock --nofork -c '#4ff28f' -f -e";
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
      focused_border_width = 1.5;
      border_width = 1;
      gapless_monocle = true;
      borderless_monocle = true;
      active_border_color = "#F3a7fF";
      focused_border_color = "#F3a7FF";
      window_gap = 0.5;
      split_ratio = 0.5;
    };
    extraConfigEarly = builtins.concatStringsSep "\n" [
      ''
        ~/.config/polybar-themes/setup.sh &
        export __GL_SYNC_TO_VBLANK=0
      ''
    ];
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        xss-lock --transfer-sleep-lock -- i3lock --nofork -c "#5f0f9f" -i ~/Pictures/lock.png -f -e&
        flameshot &
        xwallpaper --maximize ~/Pictures/pape.png
        ~/.config/polybar/launch.sh --forest
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
