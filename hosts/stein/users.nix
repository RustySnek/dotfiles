{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;

  programs.fish.enable = true;
  users.users.root = {password = "1234";};
  users.users.poro = {
  
    # passwordFile = config.age.secrets.q.path;
    password = "1234";
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "docker" "adbusers" "input" "video"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsVuTtnuAJ8c1lhvDyvuaTaVh0KvL+g2F7zizMkIC7Y user@samsung-klte"
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUbYWpmEjinPusFY62EAGsj+RR/R/r36NgvJaURmzWQzk2Wq5WlQfbow275xRavKxutzsF8HEA0Vuv3oGmrpuIFr1Uccipjmu1NixlkG/NDejsanoPgtl2N37iTgHfTJvQMI2q0DObAjag0sKdAv927tJEKMx9fRIgvDs1yhlTSN1Is+tbMmJzwbV4YPP7v7FkNYzAtEz/eSmkr/DE+6IZajW4F5zDqx7WUDgZ8MqTIdRhKJf/RwZuw0LMSoNoI8TXYLg9zhWiP7yoAt2pZpPLs+aNLmseUbj4y7x8XMcjgbvvmgtGkOjB1KLErO+up29Xd08j29dcd62Ffsja4PizBLRRTSHKo5ipxqwOEMhG/F3ULfw5Fd2dLsBjldFflwEQDm23203LPRe3mPZg6CdYkARpE840VP9K9BlUatEcpmopNzOg7zRupj//4jKEOAetiNnYp+HrQqSshglD8fbo/Ez8t/0OFvo5vrBElPkiCIyPH62H1CRhSfjXM2xDgmc= root@samsung-klte"
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
