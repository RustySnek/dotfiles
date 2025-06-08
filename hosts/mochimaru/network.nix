{...}: {
  networking = {
   networkmanager.enable = true;
     };
environment.persistence."/nix/persist/system" = {
     directories = [
      "/etc/NetworkManager"
     ];
   };

}
