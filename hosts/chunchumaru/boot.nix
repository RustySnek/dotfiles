{ pkgs, config, ... }:
{
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/EFI";
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.unstable.linuxKernel.packages.linux_zen;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "nvme"
    "amdgpu"
    "dm-snapshot"
    "i2c-dev"
    "i2c-piix4"
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
  ];
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
  ];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot-backup".preLVM = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
    kvmfr
  ];
}
