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
    inetutils
    nmap
    winetricks
    power-profiles-daemon
    picom
    krita
    gscreenshot
    lsof
    neofetch
    rust-analyzer
    ouch
    yt-dlp
    ffmpeg-full
    glibc
    netcat-gnu
    gobuster
    metasploit
    musikcube
    xclip
    wget
    xwallpaper
    xss-lock
    i3lock
    rofi
    dmenu
    fd
    python312Packages.tree-sitter
    tree-sitter
    vimPlugins.nvim-treesitter
    ungoogled-chromium
    polybar
    python312Packages.pynvim
    python312
    qbittorrent
    mpv
    ripgrep
    flatpak
    xorg.xinit
  ];

  services.udiskie.enable = true;
  xdg.enable = true;
  home.persistence."/nix/persist/home/rustysnek" = {
    directories = [
      ".local/share/docker"
      ".local/state/wireplumber"
      ".config/rofi"
      ".config/polybar"
      ".config/polybar-themes"
      ".local/bin"
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
  home.stateVersion = "24.11";
}
