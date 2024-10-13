{
  pkgs,
  impermanence,
  ...
}: {
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    ./direnv.nix
    #./i3.nix
    ./bspwm.nix
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
  (openrazer-daemon.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.gobject-introspection pkgs.wrapGAppsHook3 pkgs.python3Packages.wrapPython];
      }))
   (retroarch.override {
    cores = with libretro; [
      beetle-psx-hw
      ppsspp
    ];
  })
  polychromatic
  wine
  jre8
  openvpn
  lutris
  exploitdb
  macchanger
  zap
  inetutils
  john
  nmap
  winetricks
  picom
  krita
  gscreenshot
  p7zip
  pciutils
  usbutils
  lsof
  neofetch
  rust-analyzer
  unzip
  yt-dlp
  ffmpeg-full
  glibc
  netcat-gnu
  wireshark
  gobuster
  metasploit
  musikcube
  xclip
  mysql
  wget
  xwallpaper
  xss-lock
  i3lock
  rofi
  dmenu
  fd
  python311Packages.tree-sitter
  tree-sitter
  opentabletdriver
  vimPlugins.nvim-treesitter
  polybar
  python311Packages.pynvim
  python311
  qbittorrent
  mpv
  ripgrep
  flatpak
  xorg.xinit
  ];

services.udiskie.enable = true;
  xdg.enable = true;
  #xdg.configFile."polybar".enable = true;
  #xdg.configFile."polybar".source = ./polybar;
  home.persistence."/nix/persist/home/rustysnek" = {
    directories = [
      ".local/share/docker"
      ".local/state/wireplumber"
      ".config/rofi"
      ".wine"
      ".config/polybar"
      ".config/polybar-themes"
      ".local/share/lutris"
      ".local/share/qbittorrent"
      "Games"
    ];
    allowOther = true;
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.stateVersion = "24.05";
}
