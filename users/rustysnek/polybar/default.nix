{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.polybar-forest;

  # `current` points at one of the built themes; the style switcher flips it and
  # `polybar-msg cmd restart` re-reads config.ini through the link
  stateDir = "${config.xdg.stateHome}/polybar-forest";

  # polybar trims values unless they are quoted
  iniValue = v: if lib.hasPrefix " " v || lib.hasSuffix " " v then ''"${v}"'' else v;
  iniSection = name: attrs: ''
    [${name}]
    ${lib.concatStrings (lib.mapAttrsToList (k: v: "${k} = ${iniValue v}\n") attrs)}'';

  themeNames = lib.attrNames cfg.themes;
  menuEntry = name: "${cfg.themes.${name}.menuIcon} ${cfg.themes.${name}.label}";

  styles = pkgs.writeText "styles.sh" ''
    #!/usr/bin/env bash

    # Switch the bars to another theme from themes.nix until the next activation
    STATE="${stateDir}"

    theme="''${1#--}"
    if [[ "$1" != --* || ! -e "$STATE/themes/$theme" ]]; then
    	echo "No option specified, Available options:"
    	echo "${lib.concatMapStringsSep " " (n: "--${n}") themeNames}"
    	exit 1
    fi

    ln -sfn "themes/$theme" "$STATE/current"
    ${cfg.package}/bin/polybar-msg cmd restart
  '';

  styleSwitch = pkgs.writeText "style-switch.sh" ''
    #!/usr/bin/env bash

    SDIR="@forest@/scripts"

    # Launch Rofi
    MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p ''' \
    -theme $SDIR/rofi/styles.rasi \
    <<< ${lib.escapeShellArg (lib.concatMapStrings (n: "${menuEntry n}|") themeNames)})"
    case "$MENU" in
    ${
      lib.concatMapStrings (
        n: "\t${lib.escapeShellArg (menuEntry n)}) \"$SDIR\"/styles.sh --${n} ;;\n"
      ) themeNames
    }esac
  '';

  mkForest =
    name: theme:
    pkgs.runCommand "polybar-forest-${name}" { } ''
      cp -r ${./forest} $out
      chmod -R u+w $out
      cp ${
        pkgs.writeText "colors.ini" (
          iniSection "color" ({ inherit (theme) background foreground sep; } // theme.palette)
        )
      } $out/colors.ini
      cp ${pkgs.writeText "icons.ini" (iniSection "icon" theme.icons)} $out/icons.ini
      cp ${pkgs.writeText "colors.rasi" ''
        /* colors */

        * {
          al:   #00000000;
          bg:   ${theme.background}FF;
          bga:  ${theme.backgroundAlt}FF;
          fg:   ${theme.foreground}FF;
          ac:   ${theme.accent}FF;
          se:   ${theme.selected}FF;
        }
      ''} $out/scripts/rofi/colors.rasi
      install -m755 ${styles} $out/scripts/styles.sh
      install -m755 ${styleSwitch} $out/scripts/style-switch.sh
      find $out -type f -exec sed -i -e "s|@forest@|$out|g" -e "s|@net@|${theme.net}|g" {} +
      patchShebangs $out
    '';

  themes = pkgs.linkFarm "polybar-forest-themes" (lib.mapAttrs mkForest cfg.themes);

  # replaces ~/.config/polybar/launch.sh --forest
  launcher = pkgs.writeShellScriptBin "polybar-forest" ''
    state="${stateDir}"
    mkdir -p "$state"
    ln -sfn ${themes} "$state/themes"
    [[ -e "$state/current" ]] || ln -sfn themes/${cfg.theme} "$state/current"

    # Terminate already running bar instances
    ${pkgs.procps}/bin/pkill -x polybar

    # Wait until the processes have been shut down
    while ${pkgs.procps}/bin/pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

    # Launch the bar
    ${cfg.package}/bin/polybar -q main -c "$state/current/config.ini" &
    ${cfg.package}/bin/polybar -q secondary -c "$state/current/config.ini" &
  '';

  colorOption =
    description:
    lib.mkOption {
      type = lib.types.str;
      inherit description;
    };

  themeType = lib.types.submodule (
    { name, config, ... }:
    {
      options = {
        label = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "Entry text in the style switcher menu.";
        };
        menuIcon = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Glyph shown before the label in the style switcher menu.";
        };
        background = colorOption "Bar background, [color] background.";
        foreground = colorOption "Bar foreground, [color] foreground.";
        sep = colorOption "Separator colour, [color] sep.";
        backgroundAlt = colorOption "Rofi menu input/element background (bga).";
        accent = colorOption "Rofi menu accent (ac).";
        selected = colorOption "Rofi menu selection (se).";
        net = lib.mkOption {
          type = lib.types.str;
          default = config.palette.indigo;
          description = "Download arrow in the network label, inlined since polybar can't reference colours inside a label.";
        };
        palette = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "Remaining [color] keys: accents used by the modules, foreground-icon and ws-empty.";
        };
        icons = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "[icon] keys referenced from the modules as \${icon.<name>}.";
        };
      };
    }
  );
in
{
  options.programs.polybar-forest = {
    enable = lib.mkEnableOption "the adi1090x forest polybar theme";

    package = lib.mkPackageOption pkgs "polybar" { };

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "default";
      description = "Theme the bars start with after boot or activation.";
    };

    themes = lib.mkOption {
      type = lib.types.attrsOf themeType;
      default = { };
      description = "Colour/icon sets, each built into its own copy of the forest config.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.polybar-forest.themes = import ./themes.nix;

    home.packages = [ launcher ];

    # what polybar-themes/setup.sh used to copy into ~/.local/share/fonts on boot
    xdg.dataFile."fonts/polybar".source = ./fonts;

    home.activation.polybarForest = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      old=$(readlink -f "${stateDir}/current" || true)
      run mkdir -p "${stateDir}"
      run ln -sfn ${themes} "${stateDir}/themes"
      run ln -sfn themes/${cfg.theme} "${stateDir}/current"
      if [[ ! -v DRY_RUN && "$(readlink -f "${stateDir}/current")" != "$old" ]]; then
        XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$UID}" \
          ${cfg.package}/bin/polybar-msg cmd restart >/dev/null 2>&1 || true
      fi
    '';
  };
}
