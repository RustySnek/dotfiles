{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;

  age.secrets.q.file = ../../secrets/q.age;

  programs.fish.enable = true;
  users.users.root = {password = "1234";};
  users.users.q = {
    # passwordFile = config.age.secrets.q.path;
    password = "1234";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input"];
    shell = pkgs.fish;
  };

  users.users.poro = {
    # passwordFile = config.age.secrets.q.path;
    password = "1234";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input"];
    shell = pkgs.fish;
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
