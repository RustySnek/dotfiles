{ pkgs, ... }:
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
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
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
  boot.initrd.luks.devices."cryptroot".preLVM = true;
  services.libinput = {
    enable = false;
  };
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.xterm.enable = false;
    windowManager.bspwm.enable = true;
    displayManager.lightdm.enable = true;
  };
  services.displayManager = {
    defaultSession = "none+bspwm";
  };

  boot.extraModulePackages = with pkgs; [
    unstable.linuxKernel.packages.linux_zen.v4l2loopback
    unstable.linuxKernel.packages.linux_zen.kvmfr
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "rustysnek" ];

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.cpu.amd.updateMicrocode = true;
}
