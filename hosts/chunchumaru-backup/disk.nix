{
  lib,
  disks ? [ "/dev/nvme1n1" ],
  ...
}:
{
  disko.devices = {
    disk = lib.genAttrs disks (dev: {
      type = "disk";
      device = dev;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/EFI";
              mountOptions = [ "defaults" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot-backup";
              extraOpenArgs = [ "--allow-discards" ];
              passwordFile = "/tmp/secret.key";
              content = {
                type = "lvm_pv";
                vg = "pool-backup";
              };
            };
          };
        };
      };
    });
    lvm_vg = {
      pool-backup = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };

    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=4G"
          "mode=755"
        ];
      };
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [ "size=4G" ];
      };
    };
  };
}
