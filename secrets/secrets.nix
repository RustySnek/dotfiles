let
  chunchumaruHostRSA = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILfVA3zOPJgdbwA3m18Xic/LKBIEAfP4LkRFZNs4H9rA rustysnek@chunchumaru";
  chunchumaru = [chunchumaruHostRSA];
in {
  "rustysnek.age".publicKeys = chunchumaru;
}
