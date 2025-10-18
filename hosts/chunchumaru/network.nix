{ ... }:
{
  networking.useDHCP = true;
  networking.dhcpcd.wait = "background";
  networking.nameservers = [ "1.1.1.1" ];
  networking.extraHosts = ''
    127.0.0.1 localstack
    127.0.0.1 judge_server
    127.0.0.1 judge-api-server-1
  '';
}
