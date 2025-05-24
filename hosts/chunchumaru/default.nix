{
  lib,
  pkgs,
  agenix,
  ...
}:
{
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = [ "/dev/nvme0n1" ];
    })
    ./boot.nix
    ./persistence.nix
    ./libvirt.nix
    ./rgb.nix
    ./users.nix
    ./docker.nix
    ./gpg.nix
    ./network.nix
    ./misc.nix
    ./audio.nix
    ./udev.nix
  ];
  security.pam.services.i3lock.enable = true;
  swapDevices = [
    { device = "/nix/persist/swapfile"; }
  ];
  services.deepcool-digital = {
    enable = true;
    mode = "temp";
    use_fahrenheit = false;
    alarm = true;
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];
    enableTCPIP = true;
    settings.port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''

      #...

           local all       all     trust
         #type database DBuser origin-address auth-method
         # ipv4
         host  all      all     127.0.0.1/32   trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };
  services.devmon.enable = true;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 2;
  };
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

  age.identityPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];
  time.timeZone = "Europe/Warsaw";

  virtualisation.docker.enableNvidia = false;
  hardware.opentabletdriver.enable = true;
  programs.dconf.enable = true;
  programs.gamemode.enable = true;
  programs.command-not-found.enable = false;

  environment.systemPackages = with pkgs; [
    unstable.devenv
    unstable.neovim
    agenix.packages.x86_64-linux.default
    virt-manager
    man-pages
    man-pages-posix
    fzf
    jq
    nixfmt-rfc-style
    nil
    floorp
  ];

  fonts.packages =
    with pkgs;
    [
      migu
      baekmuk-ttf
      quicksand
      nanum
      noto-fonts-emoji
      twemoji-color-font
      openmoji-color
      twitter-color-emoji
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.settings.trusted-users = [ "rustysnek" ];
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org"
    "https://devenv.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = "chunchumaru";
  system.stateVersion = "25.05";
}
