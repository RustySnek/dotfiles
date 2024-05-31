let
  mochimaruHostRSA = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXhj85tG8OMs7tdfyQHF+h36zqqZ+1VyJEUGeGAnT/Y root@mochimaru";
  mochimaru = [mochimaruHostRSA];
in {
  "rustysnek.age".publicKeys = mochimaru;
}


