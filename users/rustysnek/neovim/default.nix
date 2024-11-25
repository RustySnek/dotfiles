{pkgs, ...}: {
  xdg = {
    enable = true;
  };

  home.packages = with pkgs; [
    neovim
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

  home.file.".config/nvim" = {
    force = true;
    source = ./nvim;
    recursive = false;
  };

  home.persistence."/nix/persist/home/rustysnek" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
