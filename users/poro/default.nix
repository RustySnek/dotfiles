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
nvidia-docker
power-profiles-daemon
picom
gscreenshot
rust-analyzer
    brillo
unzip
yt-dlp
    xclip
    xwallpaper
    xss-lock
    i3lock
    rofi
    dmenu
    fd
    python310Packages.tree-sitter
    tree-sitter
    vimPlugins.nvim-treesitter
    brave
    polybar
    python310Packages.pynvim
    python310
    qbittorrent
    mpv
    ripgrep
    xorg.xinit
  ];
services.udiskie.enable = true;
  xdg.enable = true;
  #xdg.configFile."polybar".enable = true;
  #xdg.configFile."polybar".source = ./polybar;
  home.persistence."/nix/persist/home/poro" = {
    directories = [
".local/share/docker"
      ".local/state/wireplumber"
      ".config/rofi"
      ".config/polybar"
      ".config/polybar-themes"
      ".config/lvim"
      ".local/bin/"
    ];
    allowOther = true;
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.stateVersion = "23.05";
}
