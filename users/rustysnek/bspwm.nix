{ pkgs, ... }:
let
  # i3lock takes a single image for the whole X screen, so build one from a
  # picture per monitor (scaled to fill it), cached until the monitor layout
  # or the pictures change. Falls back to a plain colour lock if that fails.
  lockScreen = pkgs.writeShellApplication {
    name = "lock-screen";
    runtimeInputs = with pkgs; [
      xrandr
      imagemagick
      i3lock
      coreutils
      gawk
    ];
    text = ''
      pics="$HOME/Pictures"
      cache="''${XDG_CACHE_HOME:-$HOME/.cache}/lock-screen"

      picture_for() {
        if [ "$1" = HDMI-A-0 ] && [ -f "$pics/lock-2.png" ]; then
          echo "$pics/lock-2.png"
        else
          echo "$pics/lock.png"
        fi
      }

      # "name width height x y" per active monitor
      layout=$(xrandr --listactivemonitors | awk 'NR > 1 { split($3, g, "[/x+]"); print $4, g[1], g[3], g[5], g[6] }')

      width=0 height=0 key="$layout" parts=()
      while read -r name w h x y; do
        [ -n "$name" ] || continue
        pic=$(picture_for "$name")
        key+=" $(stat -c '%n %s %Y' "$pic" 2>/dev/null || true)"
        parts+=("(" "$pic" -resize "''${w}x''${h}^" -gravity center -extent "''${w}x''${h}" ")"
          -gravity northwest -geometry "+$x+$y" -composite)
        width=$((x + w > width ? x + w : width))
        height=$((y + h > height ? y + h : height))
      done <<<"$layout"

      out="$cache/$(sha1sum <<<"$key" | cut -c1-16).png"
      if [ ! -f "$out" ]; then
        mkdir -p "$cache"
        rm -f "$cache"/*.png
        magick -size "''${width}x''${height}" xc:black "''${parts[@]}" \
          -depth 8 -define png:compression-level=1 "PNG:$out.tmp" && mv "$out.tmp" "$out" || true
      fi

      if [ -f "$out" ]; then
        exec i3lock -i "$out" "$@"
      fi
      exec i3lock "$@"
    '';
  };
in
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
      },
      # gromit-mpx annotation overlay: a fullscreen ARGB window, so blurring its
      # background blurs the whole screen. No blur/shadow/fade/spawn animation.
      {
        match = "class_g ?= 'gromit-mpx'";
        blur-background = false;
        shadow = false;
        fade = false;
        animations = ( { triggers = [ "open" ]; opacity = { duration = 0.01; start = 1; end = 1; }; } );
      }
    );

    animations = (
      { triggers = [ "open" ];     preset = "appear";          scale = 0.2; duration = 0.15; },
      { triggers = [ "geometry" ]; preset = "geometry-change";              duration = 0.15; }
    );
  '';
  # Idle/suspend lock as a user service (not bspwmrc, which only runs at
  # login) so a switch restarts it with the current lock command. xautolock
  # off: xss-lock follows the X screensaver timeout (600s, as before).
  services.screen-locker = {
    enable = true;
    xautolock.enable = false;
    xss-lock.extraOptions = [ "--transfer-sleep-lock" ];
    lockCmd = ''${lockScreen}/bin/lock-screen --nofork -c "#5f0f9f" -f -e'';
  };
  services.sxhkd.enable = true;
  # sxhkd only reads its config at startup; make a switch reload it.
  xdg.configFile."sxhkd/sxhkdrc".onChange = "${pkgs.procps}/bin/pkill -USR1 -x sxhkd || true";
  services.sxhkd.keybindings = {
    "super + Return" = "kitty ~";
    "super + b" = "~/Projects/VM/toggle.sh";
    # "Print" = "gscreenshot -sc";
    "Print" = "flameshot gui";
    "super + @space" = "~/.config/rofi/launchers/type-5/launcher.sh";
    "super + alt + l" = "${lockScreen}/bin/lock-screen --nofork -f -e -c '#4ff28f'";
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
        flameshot &
        xwallpaper --stretch ~/Pictures/pape.jpg &
        # polybar's alsa module disables itself if wireplumber hasn't published a default sink yet
        for _ in $(seq 100); do wpctl inspect @DEFAULT_AUDIO_SINK@ >/dev/null 2>&1 && break; sleep 0.1; done
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
