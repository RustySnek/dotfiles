{
  pkgs,
  impermanence,
  ...
}: {
  imports = [
    impermanence.nixosModules.home-manager.impermanence
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
  home.persistence."/nix/persist/home/poro" = {
    directories = [];
    allowOther = true;
  };
  home.stateVersion = "23.05";
}
