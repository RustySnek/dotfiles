{ pkgs, lib, ... }:
let
  # Theme settings travel with the binary, so any launcher works, including
  # sxhkd and the daemon from a session older than the last switch.
  dolphin = pkgs.symlinkJoin {
    name = "dolphin-themed";
    paths = [ pkgs.kdePackages.dolphin ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/dolphin \
        --set QT_QPA_PLATFORMTHEME kde \
        --prefix QT_PLUGIN_PATH : ${
          lib.makeSearchPath "lib/qt-6/plugins" [
            pkgs.kdePackages.plasma-integration
            pkgs.darkly
          ]
        } \
        --prefix XDG_CONFIG_DIRS : ${kiosk}/etc/xdg
    '';
  };
  # Kiosk lock: an immutable group in a system-level dolphinrc beats
  # ~/.config/dolphinrc, so a pick from Menu > Window Color Scheme lasts only
  # for that window instead of replacing the colours below.
  kiosk = pkgs.writeTextDir "etc/xdg/dolphinrc" "[UiSettings][$i]\n";
  # Propo keeps Nerd Font glyphs at natural width for UI text; the plain
  # variant squeezes them into one terminal cell.
  font = size: "VictorMono Nerd Font Propo,${toString size}";
  # KConfig and KBookmarks save by renaming a temp file over the target, which
  # fails (EBUSY) on a bind-mounted file, so these are symlinks instead. Saving
  # through a dangling link silently does nothing; dolphinState creates targets.
  persistedFiles = [
    ".config/dolphinrc" # settings
    ".local/state/dolphinstaterc" # window size, panel and toolbar layout
    ".local/share/user-places.xbel" # Places panel (pinned folders)
    ".config/darklyrc" # Darkly style options (darkly-settings6)
  ];
  # Halloween palette from fish.nix/fastfetch.nix plus dark bases, as KConfig r,g,b.
  halloween = {
    void = "18,15,22"; # file view
    crypt = "24,20,30"; # window, toolbar
    tomb = "31,26,38"; # alternate rows, tooltips
    grave = "40,33,50"; # buttons
    ash = "140,130,150"; # inactive text
    bone = "233,228,212";
    pumpkin = "255,117,24";
    candy = "255,195,0";
    slime = "118,215,43";
    blood = "215,38,61";
    witch = "155,93,229";
  };
  colorSet =
    bg: alt: fg: with halloween; {
      BackgroundNormal = bg;
      BackgroundAlternate = alt;
      ForegroundNormal = fg;
      ForegroundInactive = ash;
      ForegroundActive = pumpkin;
      ForegroundLink = candy;
      ForegroundVisited = witch;
      ForegroundNegative = blood;
      ForegroundNeutral = candy;
      ForegroundPositive = slime;
      DecorationFocus = pumpkin;
      DecorationHover = witch;
    };
in
{
  home.packages = [
    dolphin
    pkgs.darkly # darkly-settings6
  ];

  # dolphinrc rather than kdeglobals, so all of this stays Dolphin-only. The
  # colours go in as config groups, not a scheme from Menu > Window Color
  # Scheme: Dolphin pins the file view's text colour from the platform palette
  # (KItemListContainer::setEnabledFrame), so a per-app scheme leaves file
  # names in the old colour.
  qt.kde.settings.dolphinrc = with halloween; {
    General = {
      font = font 11;
      menuFont = font 11;
      toolBarFont = font 11;
      smallestReadableFont = font 9;
      fixed = "VictorMono Nerd Font Mono,11";
    };
    KDE = {
      widgetStyle = "Darkly";
      contrast = 4;
    };
    UiSettings.ColorScheme = null;
    "Colors:Window" = colorSet crypt tomb bone;
    "Colors:View" = colorSet void crypt bone;
    "Colors:Header" = colorSet crypt tomb bone;
    "Colors:Button" = colorSet grave tomb bone;
    "Colors:Tooltip" = colorSet tomb crypt bone;
    "Colors:Complementary" = colorSet void crypt bone;
    "Colors:Selection" = colorSet pumpkin "128,58,12" void // {
      ForegroundActive = void;
      ForegroundInactive = grave;
      ForegroundLink = void;
      ForegroundVisited = grave;
    };
    "ColorEffects:Inactive".Enable = false;
  };

  home.persistence."/nix/persist" = {
    files = map (file: {
      inherit file;
      method = "symlink";
    }) persistedFiles;
    directories = [
      ".local/share/dolphin" # per-folder view properties
      ".local/share/kxmlgui5" # customised toolbars and shortcuts
    ];
  };

  home.activation.dolphinState = lib.hm.dag.entryBetween [ "kconfig" ] [ "writeBoundary" ] ''
    for f in ${lib.escapeShellArgs persistedFiles}; do
      target=$(readlink -f "$HOME/$f")
      [ -e "$target" ] || run touch "$target"
    done
  '';

  # ksycoca indexes applications through this XDG menu; only Plasma ships one,
  # so without it "Open With" and file associations come up empty.
  xdg.configFile."menus/applications.menu".text = ''
    <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
     "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
    <Menu>
      <Name>Applications</Name>
      <DefaultAppDirs/>
      <DefaultDirectoryDirs/>
      <Include><All/></Include>
    </Menu>
  '';

  # Dolphin's FileManager1 daemon, started with the session so Qt/KF6 are
  # already resident when the first window opens. Same name as the packaged
  # unit, so D-Bus activation of org.freedesktop.FileManager1 uses this one.
  # No BusName: it implies Type=dbus, and every Dolphin window also queues for
  # FileManager1, so starting this with a window open blocks until timeout.
  systemd.user.services.plasma-dolphin = {
    Unit = {
      Description = "Dolphin file manager daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${dolphin}/bin/dolphin --daemon";
      Slice = "background.slice";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
