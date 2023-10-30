{
  pkgs,
  impermanence,
  ...
}: {
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    ./bspwm.nix
    ./direnv.nix
    ./git.nix
    ./kitty.nix
    ./ssh.nix
    ./fish.nix
    ./gpg.nix
    ./neovim
  ];
  home.packages = with pkgs; [
    gotop
    picom
    brillo
    xclip
    flameshot
    xwallpaper
    xss-lock
    i3lock
    rofi
    dmenu
    brave
    polybar
    qbittorrent
    mpv
    xorg.xinit
  ];
  services.udiskie.enable = true;
  xdg.enable = true;
  #xdg.configFile."polybar".enable = true;
  #xdg.configFile."polybar".source = ./polybar;
  home.persistence."/nix/persist/home/poro" = {
    directories = [".config/picom" ".config/rofi" ".config/polybar" ".config/polybar-themes"];
    allowOther = true;
  };
  home.stateVersion = "23.05";
}
