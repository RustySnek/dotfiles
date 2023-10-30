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
    qbittorrent
    mpv
    xorg.xinit
  ];
  services.udiskie.enable = true;
  xdg.enable = true;
#   home.persistance."/nix/persist/home/poro".allowOther = true;
#   home.persistance."/nix/persist/home/poro" = {
 #  directories = [];
  # };
  home.stateVersion = "23.05";
}
