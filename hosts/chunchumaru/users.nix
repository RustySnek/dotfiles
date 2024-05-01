{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;

  programs.fish.enable = true;
  age.secrets.poro.file = ../../secrets/poro.age;
  users.users.poro = {
    hashedPasswordFile = config.age.secrets.poro.path;
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input" "video"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
    ];
  };

  # these are host specific
  # for more general ones set them using home-manager
  environment.persistence."/nix/persist" = {
    users.poro.directories = [
      "Projects"
      "Documents"
      "Music"
      "Pictures"
      ".config/BraveSoftware"
    ];
  };
}
