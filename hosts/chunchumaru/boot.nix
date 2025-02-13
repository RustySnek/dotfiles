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
  boot.kernelPackages = pkgs.unstable.linuxPackages_6_12;
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
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;
  services.xserver = {
    enable = true;
    layout = "us";
    libinput = {
      enable = false;
    };

    desktopManager.xterm.enable = false;
    windowManager.bspwm.enable = true;

    displayManager = {
      defaultSession = "none+bspwm";
      lightdm.enable = true;
    };
  };

  boot.extraModulePackages = with pkgs; [
    unstable.linuxPackages_6_12.v4l2loopback
    unstable.linuxPackages_6_12.kvmfr
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "rustysnek" ];

  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.cpu.amd.updateMicrocode = true;
}
