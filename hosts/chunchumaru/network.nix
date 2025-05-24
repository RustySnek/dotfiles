{ ... }:
{
  networking.useDHCP = true;
  networking.dhcpcd.wait = "background";
  networking.nameservers = [ "1.1.1.1" ];
}
