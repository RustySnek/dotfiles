{ suites, lib, config, pkgs, profiles, callPackage, ... }:

{
  imports = suites.base
    ++ suites.impermanence
    ++ suites.audio
    ++ suites.dev
    ++ [ profiles.virt.common ]
    ++ [ ./network.nix ./boot.nix ./power.nix ./video.nix ./device.nix ./storage.nix ./persistence.nix ./package.nix ./docker ./printing.nix ./udev.nix ./memory.nix ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  time.timeZone = "Europe/Warsaw";

  security.polkit.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.extraOptions = ''
    extra-experimental-features = nix-command flakes
    extra-substituters = https://nrdxp.cachix.org https://nix-community.cachix.org
    extra-trusted-public-keys = nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.extra-substituters = [
    "https://nrdxp.cachix.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  home-manager.users.q = {
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "kitty";
        startup = [
          {
            command = "${pkgs.sway}/bin/swaymsg output e-DP-1 bg $(shuf -n1 -e ~/Pictures/Wallpapers/Landscape/*) fill";
            always = true;
          }
        ];
      };
    };
  };

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty? ]] && sudo /run/current-system/sw/bin/lock this
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  # home-manager.users.q = {
  #   xsession.windowManager.i3.config = {
  #     startup = [
  #       {
  #         command = "${pkgs.xwallpaper}/bin/xwallpaper --output eDP --zoom $(shuf -n1 -e ~/Pictures/Wallpapers/Landscape/*)";
  #         notification = false;
  #         always = true;
  #       }
  #     ];

  #     workspaceOutputAssign = [
  #       {
  #         workspace = "1";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "2";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "3";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "4";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "5";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "6";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "7";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "8";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "9";
  #         output = "eDP";
  #       }
  #       {
  #         workspace = "10";
  #         output = "eDP";
  #       }
  #     ];
  #   };
  # };


  programs.dconf.enable = true;

  system.stateVersion = "22.11";
}
