{ ... }:
{
  home.persistence."/nix/persist/home/rustysnek".files = [
    ".ssh/id_rsa"
    ".ssh/id_rsa.pub"
    ".ssh/id_ed25519.pub"
    ".ssh/id_ed25519"
  ];
}
