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
(openrazer-daemon.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.gobject-introspection pkgs.wrapGAppsHook3 pkgs.python3Packages.wrapPython];
        }))

    polychromatic
element-web
wine
jre8
openvpn
lutris
exploitdb
zap
inetutils
john
nmap
autokey
winetricks
power-profiles-daemon
picom
krita
gscreenshot
osu-lazer
p7zip
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
    kazam
    dmenu
    fd
    python310Packages.tree-sitter
    tree-sitter
    opentabletdriver
    vimPlugins.nvim-treesitter
    ungoogled-chromium
    polybar
    python310Packages.pynvim
    python310
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
      ".paddleocr/"
      ".wine"
      ".config/polybar"
      ".config/polybar-themes"
      ".config/lvim"
      ".local/share/lvim"
      ".local/share/osu"
      ".local/bin"
      ".local/share/Steam"
      ".steam/"
      ".local/share/lutris"
      ".local/share/qbittorrent"
      "Games"
      ".cache/huggingface"
    ];
    allowOther = true;
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.stateVersion = "24.05";
}
