{ config, lib, pkgs, ... }:

{
  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/docker"
      "/etc/NetworkManager/system-connections/"
      "/var/lib/libvirt"
    ];
    users.q.directories = [
      "Projects"
      ".wine"
      ".local/share/lutris"
      ".local/share/Steam"
      ".local/share/applications"
      "Games"
      ".config/lutris"
      "Pictures"
      ".config/PCSX2"
      "Videos"
      "Music"
    ];
  };

}
