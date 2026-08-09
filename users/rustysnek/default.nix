{
  pkgs,
  impermanence,
  ...
}:
{
  imports = [
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
    #nvidia-docker
    wine
    jre8
    nextcloud-client
    openvpn
    lutris
    inetutils
    nmap
    winetricks
    power-profiles-daemon
    picom
    krita
    gscreenshot
    flameshot
    unstable.brave
    # CLI/system utils
    xdotool
    unzip
    p7zip
    openssl
    pciutils
    usbutils
    fastfetch
    tailscale
    lsof
    rust-analyzer
    ouch
    unstable.claude-code
    unstable.gemini-cli
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
  home.file.".config/polybar-themes" = {
    force = true;
    source = ./polybar-themes;
  };
  home.file.".config/polybar" = {
    force = true;
    source = ./polybar;
  };
  home.file.".config/rofi" = {
    force = true;
    source = ./rofi;
  };

  home.persistence."/nix/persist" = {
    directories = [
      ".local/share/docker"
      ".local/state/wireplumber"
      ".local/bin"
      ".local/share/lutris"
      ".local/share/qbittorrent"
      "Games"
      ".cache/huggingface"
    ];
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.stateVersion = "26.05";
}
