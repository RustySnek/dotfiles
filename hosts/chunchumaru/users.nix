{ config, pkgs, ... }:
{
  users.mutableUsers = false;

  programs.fish.enable = true;
  age.secrets.rustysnek.file = ../../secrets/rustysnek.age;
  users.users.rustysnek = {
    hashedPasswordFile = config.age.secrets.rustysnek.path;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "docker"
      "adbusers"
      "kvm"
      "input"
      "video"
      "openrazer"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ ];
  };

  # these are host specific
  # for more general ones set them using home-manager
  environment.persistence."/nix/persist" = {
    users.rustysnek.directories = [
      "Projects"
      "Documents"
      "Music"
      "Pictures"
      ".config/retroarch"
      ".config/lutris"
      ".var/app/"
      ".mozilla"
      ".config/BraveSoftware"
    ];
  };
}
