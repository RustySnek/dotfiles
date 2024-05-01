let
	chunchumaruHostRSA = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKt+SpHfKBN8/7Cdc1lrKy54NYZ9d6J6moL8pe9kINUf rustysnek@chunchumaru";
	chunchumaru = [ chunchumaruHostRSA];
in {
  "rustysnek.age".publicKeys = chunchumaru;
}

