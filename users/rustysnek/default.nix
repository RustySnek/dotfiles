{ pkgs, impermanence, ... }:
{
  imports = [
    ./direnv.nix
    ./bspwm.nix
    ./git.nix
    ./kitty.nix
    ./fastfetch.nix
    ./eza.nix
    ./ssh.nix
    ./fish.nix
    ./gpg.nix
    ./neovim
    ./tt_download.nix
    ./yt_music.nix
    ./mpv.nix
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
    (symlinkJoin {
      name = "element-desktop-wrapped";
      paths = [ element-desktop ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/element-desktop \
          --add-flags "--password-store=gnome-libsecret"
      '';
    })
    wine
    jre8
    tailscale
    openvpn
    unstable.brave
    exploitdb
    unstable.claude-code
    vesktop
    gromit-mpx
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
    (unstable.easyeffects.override {
      deepfilternet = unstable.deepfilternet; # pulls whatever version is in your current nixpkgs pin
    })
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
    gimp
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
      ".config/vesktop"
      ".config/Element"
      ".local/share/keyrings"
      ".config/rofi"
      ".config/xournalpp"
      ".config/Moonlight\ Game\ Streaming\ Project"
      ".config/WebCord"
      ".config/Cursor"
      ".config/easyeffects"
      ".wine"
      ".config/polybar"
      ".config/NextCloud"
      ".config/Nextcloud"
      ".config/OpenTabletDriver"
      ".config/polybar-themes"
      ".local/share/lutris"
      ".local/share/qbittorrent"
      "Games"
      ".claude"
      # GIMP 3.0: settings, brushes/plug-ins, and crash-recovery drafts (3.0/backups)
      ".config/GIMP"
      # GIMP swap/tile cache (gimprc swap-path defaults to the cache dir)
      ".cache/gimp"
    ];
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.05";
}
