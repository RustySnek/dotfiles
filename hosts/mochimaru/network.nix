{...}: {
  networking = {
  extraHosts = ''
    127.0.0.1 localstack
  '';
   networkmanager.enable = true;
     };
environment.persistence."/nix/persist/system" = {
     directories = [
      "/etc/NetworkManager"
     ];
   };

}
