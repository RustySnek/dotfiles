{pkgs, ...}: {
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
  boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "vfio" "vfio_iommu_type1" "vfio_pci"];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;
    windowManager.bspwm.enable = true;
    displayManager = {
      defaultSession = "none+bspwm";
      sddm.enable = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
  services.picom = {
    enable = true;
  };
  boot.kernelParams = ["module_blacklist=i915"];
  hardware.nvidia = {
    modesetting.enable = true;

<<<<<<< Updated upstream
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.

  };
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
}
