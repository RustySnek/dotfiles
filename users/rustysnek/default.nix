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
wine
jre8
openvpn
lutris
exploitdb
zap
inetutils
john
nmap
winetricks
power-profiles-daemon
picom
krita
gscreenshot
lsof
rust-analyzer
    brillo
    
unzip
yt-dlp
ffmpeg-full
glibc
yuzu
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
    kazam
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
  home.persistence."/nix/persist/home/rustysnek" = {
    directories = [
".local/share/docker"
      ".local/state/wireplumber"
      ".config/rofi"
      ".paddleocr/"
      ".wine"
      ".config/polybar"
      ".config/polybar-themes"
      ".config/lvim"
      ".local/bin"
      ".steam/"
      ".local/share/lutris"
      "Games"
      ".cache/huggingface"
    ];
    allowOther = true;
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.stateVersion = "23.11";
}
