{ ... }:
{
  environment.etc.hosts.mode = "0644";
  networking.useDHCP = true;
  networking.dhcpcd.wait = "background";
  # macvtap* belongs to a guest, not to us - dhcpcd would otherwise take a lease
  # using the guest's MAC and fight the VM over the same address.
  networking.dhcpcd.denyInterfaces = [ "macvtap*" ];
  networking.firewall = {
    checkReversePath = true;
    # Only decrypted Tailscale traffic gets a loose reverse-path check.
    # All other interfaces retain NixOS's strict check. RETURN here only
    # passes the anti-spoofing check; normal port filtering still applies.
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter 1 -i tailscale0 -m rpfilter --loose --validmark -j RETURN
    '';
    interfaces.tailscale0 = {
      # Sunshine streaming/pairing only; admin port 47990 stays local.
      allowedTCPPorts = [
        47984
        47989
        48010
      ];
      allowedUDPPorts = [
        47998
        47999
        48000
        48002
        48010
      ];
    };
  };
  networking.nameservers = [ "1.1.1.1" ];
  networking.extraHosts = ''
    127.0.0.1 localstack
    127.0.0.1 judge_server
    127.0.0.1 judge-api-server-1
  '';
}
