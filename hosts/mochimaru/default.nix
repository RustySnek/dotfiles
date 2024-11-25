{
  lib,
  pkgs,
  agenix,
  pipewire-sa,
  ...
}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/nvme0n1"];
    })
    ./boot.nix
    ./persistence.nix
    ./users.nix
    ./docker.nix
    ./gpg.nix
    ./network.nix
    ./misc.nix
    ./audio.nix
    ./udev.nix
];

services.postgresql = {
  enable = true;
  ensureDatabases = [ "mydatabase" ];
  enableTCPIP = true;
  port = 5432;
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
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

  age.identityPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  time.timeZone = "Europe/Warsaw";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.docker.enableNvidia = true;
  environment.systemPackages = with pkgs; [
    unstable.devenv
    agenix.packages.x86_64-linux.default
    virt-manager
    powertop
    fzf
    jq
    (firefox.override { nativeMessagingHosts = [ pkgs.pipewire-sa ]; })
  ];

  fonts.packages = with pkgs; [
    migu
    baekmuk-ttf
    quicksand
    nanum
    noto-fonts-emoji
    twemoji-color-font
    openmoji-color
    twitter-color-emoji
    nerdfonts
  ];
  nix.settings.trusted-users = ["rustysnek"];
  nix.settings.substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org" "https://devenv.cachix.org"];
  nix.settings.trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "mochimaru";
  system.stateVersion = "24.11";
}
