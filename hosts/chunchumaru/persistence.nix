{ ... }:
{
  environment.persistence."/nix/persist" = {
    directories = [
      {
        directory = "/var/lib/tailscale";
        mode = "0700";
      }
      "/var/lib/libvirt"
      "/var/lib/docker"
      "/var/lib/cups"
      "/var/lib/private/navidrome"
      "/var/lib/flatpak/"
      # Crash logs: journal and libvirt/QEMU logs, archived pstore panic dumps, core dumps.
      "/var/log"
      "/var/lib/systemd/pstore"
      "/var/lib/systemd/coredump"
    ];
  };
  # journalctl only reads journals of the current machine ID; a per-boot ID hides previous boots.
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";
  # Hard resets drop unsynced journal data; sync every second instead of every 5 minutes.
  services.journald.extraConfig = ''
    SyncIntervalSec=1s
  '';
  # Overrides systemd.conf's 2-week age (00-nixos.conf wins); coredump.conf size limits still apply.
  systemd.tmpfiles.rules = [ "d /var/lib/systemd/coredump 0755 root root -" ];
  environment.etc."ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
  environment.etc."ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
  environment.etc."ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
  environment.etc."ssh/ssh_host_ed25519_key.pub".source =
    "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";

  programs.fuse.userAllowOther = true;
}
