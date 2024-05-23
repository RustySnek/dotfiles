{pkgs, ...}: {
  xdg = {
    enable = true;
    configFile."nvim" = {
      source = ./neovim-conf;
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
    stylua
    xdg-desktop-portal
    xdg-desktop-portal-gtk
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
