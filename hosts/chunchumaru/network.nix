{ ... }:
{
  environment.etc.hosts.mode = "0644";
  networking.useDHCP = true;
  networking.dhcpcd.wait = "background";
  # macvtap* belongs to a guest, not to us - dhcpcd would otherwise take a lease
  # using the guest's MAC and fight the VM over the same address.
  networking.dhcpcd.denyInterfaces = [ "macvtap*" ];
  networking.nameservers = [ "1.1.1.1" ];
  networking.extraHosts = ''
    127.0.0.1 localstack
    127.0.0.1 judge_server
    127.0.0.1 judge-api-server-1
  '';
}
