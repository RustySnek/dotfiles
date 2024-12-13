{ pkgs, ... }:
{
  xdg = {
    enable = true;
  };

  home.file.".config/nvim" = {
    source = ./nvim-conf;
    force = true;
  };

  home.packages = with pkgs; [
    alejandra
    black
    ruff
    isort
    mypy
    ripgrep
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
