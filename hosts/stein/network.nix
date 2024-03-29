{...}: {
  networking = {
  extraHosts = ''
  172.21.0.2 poro.test.elixir
  10.10.11.242 devvortex.htb
  10.10.11.242 dev.devvortex.htb
  10.10.11.221 2million.htb
  10.10.11.252 bizness.htb
  10.10.11.249 biz.crafty.htb
  10.10.11.249 crafty.htb
  10.10.11.249 play.crafty.htb
'';
    nameservers = ["127.0.0.1" "::1"];
    networkmanager = {
      enable = true;
      dns = "none";
    };
    dhcpcd.extraConfig = "nohook resolv.conf";
  
    firewall.interfaces.wlp0s20f3.allowedTCPPorts = [8081 5000 19000];
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # server_names = [ ... ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  environment.persistence."/nix/persist/system" = {
    directories = [
      "/etc/NetworkManager"
    ];
  };
}
