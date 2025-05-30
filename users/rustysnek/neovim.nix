{ pkgs, ... }:
{
  xdg = {
    enable = true;
  };

  home.packages = with pkgs; [
    alejandra
    unstable.ruff
    ruff
    isort
    mypy
    stylua
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    lua-language-server
    gnumake
    gcc
  ];

  home.persistence."/nix/persist/home/rustysnek" = {
    directories = [ ".local/share/nvim" ];
  };
}
