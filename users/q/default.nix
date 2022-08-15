{ lib, pkgs, inputs, ... }:
{
  users.users.q = {
    password = "";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  home-manager.users.q = { profiles, ... }: {
    imports = [ profiles.doom-emacs profiles.wm.i3 ];

    programs.git = {
      enable = true;
      userEmail = "maksymilian.jodlowski@gmail.com";
      userName = "Maksymilian Jodłowski";
    };

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "VictorMono" "FiraCode" ]; })
      font-awesome
      pinentry-curses
    ];

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };

    programs.mpv.enable = true;
    home.persistence."/nix/persist/home/q" = {
      files = [
        ".ssh/id_rsa"
        ".ssh/id_rsa.pub"
      ];
      directories = [
        ".gnupg"
        ".password-store"
      ];
      allowOther = true;
    };

    programs.fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "pure";
          src = pure.src;
        }
      ];
    };

    programs.kitty = {
      enable = true;
      font = {
        name = "VictorMono NerdFont";
        size = 18;
      };
      settings = {
        shell = "${pkgs.fish}/bin/fish";
        confirm_os_window_close = 0;
      };
      theme = "Dracula";
    };

    programs.firefox.enable = true;
  };
}
