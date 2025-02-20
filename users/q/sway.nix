{
  lib,
  pkgs,
  ...
}: let
  swww_set_wallpapers_per_output = pkgs.writeScript "swww_set_wallpapers_per_output" ''
    #!${pkgs.bash}/bin/bash

    # Iterate over each image file in the directory
    for image_file in ~/Pictures/Wallpapers/Current/*; do
    	# Get the filename without the directory path and file extension
    	filename=$(basename -- "$image_file")
    	output_name="''${filename%.*}"

    	# Run the swww command with the appropriate output name
    	${pkgs.swww}/bin/swww img -o "$output_name" "$image_file" || continue
    done
  '';
  display_album_art = pkgs.writeShellScriptBin "display_album_art" ''
       ${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl \
    | ${pkgs.imv}/bin/imv -w "imv_album_art" -c center
  '';
  lock_command = pkgs.writeShellScriptBin "lock_command" ''
    ${pkgs.swaylock}/bin/swaylock \
        -i $(${pkgs.findutils}/bin/find ~/Pictures/Wallpapers -type f | ${pkgs.coreutils}/bin/shuf -n 1) \
        --daemonize \
        --ignore-empty-password \
        --show-failed-attempts
  '';
in {
  home.packages = with pkgs; [playerctl];

  home.pointerCursor = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    gtk.enable = true;
    x11.enable = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar.css;
    settings = {
      sideBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "LG Electronics LG SDQHD 205NTNH5W679"
        ];
        modules-left = ["sway/workspaces"];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };
      };
      mainBar = {
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "ASUSTek COMPUTER INC ASUS VG32V 0x0000B75D"
          "eDP-1"
        ];
        modules-left = ["sway/workspaces" "mpris"];
        modules-center = ["clock"];
        modules-right = ["battery" "memory" "cpu" "tray"];

        battery = {
          format = "{capacity}% {icon}";
          format-icons = [" " " " " " " " " "];
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
        };

        memory = {
          interval = 30;
          format = "{}%  ";
          max-length = 10;
        };

        tray = {
          icon-size = 24;
          spacing = 8;
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };

        mpris = {
          interval = 15;
          format = "<span font_family=\"Victor Mono Nerd Font\"> </span>{album} · {title}";
          on-click = "${display_album_art}/bin/display_album_art";
        };

        cpu.format = "{usage}% ";

        clock = {
          format = "   {:%R}";
          tooltip-format = "<tt><span>{calendar}</span></tt>";
          calendar.format = {
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraConfig = ''
      input * xkb_layout pl
    '';
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel --show-actions";
      window.titlebar = false;
      window.commands = [
        {
          command = "floating enable, resize set 512 512";
          criteria = {
            title = "imv_album_art";
          };
        }
      ];
      workspaceAutoBackAndForth = true;
      startup = [
        {
          command = "XDG_CONFIG_HOME=/home/q/.config ${pkgs.swaynotificationcenter}/bin/swaync";
          always = true;
        }
        {
          command = "${pkgs.swww}/bin/swww init";
        }
        {
          command = "${swww_set_wallpapers_per_output}";
          always = true;
        }
        {
          command = "systemctl --user restart waybar";
          always = true;
        }
      ];
      keybindings = lib.mkOptionDefault {
        "${modifier}+x" = "kill";
        # Focus window
        "${modifier}+n" = "focus left";
        "${modifier}+e" = "focus down";
        "${modifier}+i" = "focus up";
        "${modifier}+o" = "focus right";
        # Move window
        "${modifier}+Shift+n" = "move left";
        "${modifier}+Shift+e" = "move down";
        "${modifier}+Shift+i" = "move up";
        "${modifier}+Shift+o" = "move right";
        # Workspaces
        "${modifier}+0" = "workspace number 10";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        # Mode
        "${modifier}+u" = "layout default";
        "${modifier}+v" = "splitv";
        "${modifier}+h" = "splith";

        "${modifier}+y" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";

        # Quick launch
        "${modifier}+m" = "exec emacsclient -c";

        "${modifier}+s" = "layout default";
        "${modifier}+w" = "layout default";

        "${modifier}+p" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
      };
      modes = {
        resize = {
          # colemak
          n = "resize shrink width 50px";
          e = "resize grow height 50px";
          i = "resize shrink height 50px";
          o = "resize grow width 50px";
          # arrows
          Left = "resize shrink width 50px";
          Up = "resize grow height 50px";
          Down = "resize shrink height 50px";
          Right = "resize grow width 50px";
          # Set %
          Equal = "resize set height 50ppt";
          "1" = "resize set height 10ppt";
          "2" = "resize set height 20ppt";
          "3" = "resize set height 30ppt";
          "4" = "resize set height 40ppt";
          "5" = "resize set height 50ppt";
          "6" = "resize set height 60ppt";
          "7" = "resize set height 70ppt";
          "8" = "resize set height 80ppt";
          "9" = "resize set height 90ppt";
          Escape = "mode default";
        };
      };
      fonts = {
        names = ["VictorMono Nerd Font"];
        style = "Regular";
        size = 16.0;
      };
      bars = [];
    };
  };
}
