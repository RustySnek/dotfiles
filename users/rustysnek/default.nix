{ pkgs, impermanence, ... }:
{
  imports = [
    ./direnv.nix
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
    xdotool
    (openrazer-daemon.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
        pkgs.gobject-introspection
        pkgs.wrapGAppsHook3
        pkgs.python3Packages.wrapPython
      ];
    }))
    unstable.qbittorrent
    flameshot
    openssl
    polychromatic
    wine
    jre8
    tailscale
    openvpn
    unstable.brave
    exploitdb
    unstable.claude-code
    unstable.codex
    unstable.gemini-cli
    macchanger
    nextcloud-client
    discord
    moonlight-qt
    (pkgs.wrapOBS {
      plugins = with pkgs; [
        obs-studio-plugins.looking-glass-obs
        obs-studio-plugins.obs-websocket
      ];
    })
    inetutils
    unstable.easyeffects
    tenacity
    upscayl
    mupdf
    john
    kdePackages.kdenlive
    nmap
    winetricks
    picom
    krita
    xournalpp
    opentabletdriver
    gscreenshot
    p7zip
    pciutils
    usbutils
    lsof
    rust-analyzer
    fastfetch
    unzip
    unstable.yt-dlp
    ffmpeg-full
    glibc
    netcat-gnu
    wireshark
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
    python311Packages.tree-sitter
    tree-sitter
    vimPlugins.nvim-treesitter
    polybar
    python311Packages.pynvim
    python311
    mpv
    ripgrep
    flatpak
    xorg.xinit
  ];

  services.udiskie.enable = true;
  xdg.enable = true;
  #xdg.configFile."polybar".enable = true;
  #xdg.configFile."polybar".source = ./polybar;

  home.persistence."/nix/persist" = {
    directories = [
      ".local/share/docker"
      ".config/obs-studio"
      ".local/state/wireplumber"
      ".config/rofi"
      ".config/xournalpp"
      ".config/Moonlight\ Game\ Streaming\ Project"
      ".config/WebCord"
      ".config/Cursor"
      ".config/easyeffects"
      ".wine"
      ".config/polybar"
      ".config/NextCloud"
      ".config/OpenTabletDriver"
      ".config/polybar-themes"
      ".local/share/lutris"
      ".local/share/qbittorrent"
      "Games"
      ".claude"
    ];
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.05";
}
