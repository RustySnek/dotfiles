{
  pkgs,
  config,
  ...
}:{
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

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "vfio" "vfio_iommu_type1" "vfio_pci" "nvidia"];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;
  services.xserver = {
    enable = true;
    layout = "us";
    libinput = {
      enable = false;
    };

    desktopManager.xterm.enable = false;
    windowManager.bspwm = {
      enable = true;
    };
    displayManager = {
      defaultSession = "none+bspwm";
      lightdm.enable = true;
    };
  };

  boot.blacklistedKernelModules = ["nouveau" "nvidiafb" "amdgpu" "radeon" "intel_agp" "intel_atomisp"];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
  #forceFullCompositionPipeline = true;
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = true;
# Special config to load the latest (535 or 550) driver for the support of the 4070 SUPER
  package = let 
  rcu_patch = pkgs.fetchpatch {
    url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
    hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
  };
in config.boot.kernelPackages.nvidiaPackages.mkDriver {
   version = "535.154.05";
   sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
   sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
   openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
   settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
   persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";

   #version = "550.40.07";
   #sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
   #sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
   #openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
   #settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
   #persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";

    patches = [ rcu_patch ];
};
};
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.cpu.amd.updateMicrocode = true;
}
 

