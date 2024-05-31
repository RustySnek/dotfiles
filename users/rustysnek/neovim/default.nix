{pkgs, ...}: {
  xdg = {
    enable = true;
    configFile."nvim" = {
      source = ./nvim-conf;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    neovim
    alejandra
    black
    ruff
    isort
    mypy
    ripgrep

     xdg-desktop-portal
    xdg-desktop-portal-gtk
    stylua
    lua-language-server
    gnumake
    gcc
  ];

  home.persistence."/nix/persist/home/rustysnek" = {
    directories = [
      ".local/share/nvim"
    ];
  };
}
