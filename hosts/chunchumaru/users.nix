{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;

  programs.fish.enable = true;
  users.users.root.password = "1234";
  age.secrets.rustysnek.file = ../../secrets/rustysnek.age;
  users.users.rustysnek = {
    hashedPasswordFile = config.age.secrets.rustysnek.path;
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input" "video"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
    ];
  };

  # these are host specific
  # for more general ones set them using home-manager
  environment.persistence."/nix/persist" = {
    users.rustysnek.directories = [
      "Projects"
      "Documents"
      "Music"
      "Pictures"
      ".config/BraveSoftware"
    ];
  };
}
