let
  chunchumaruHostRSA = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU1UmwQjjYI6Z4/dyGuQaCK9MXhgLKPZnOW6gwQToQL root@chunchumaru";
  chunchumaru = [ chunchumaruHostRSA ];
in
{
  "rustysnek.age".publicKeys = chunchumaru;
}
