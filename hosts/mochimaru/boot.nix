{
  pkgs,
  config,
  ...
}:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/EFI";
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Power management kernel parameters
  boot.kernelParams = [
    # Disable NMI watchdog for deep CPU sleep (saves ~1-2W)
    "nmi_watchdog=0"

    # Enable PCI runtime power management
    "pcie_aspm=force"
    "pcie_aspm.policy=powersupersave"

    # VM writeback timeout for less frequent disk writes
    "vm.dirty_writeback_centisecs=6000"
  ];

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
    "dm-snapshot"
    "i2c-dev"
    "i2c-piix4"
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
  ];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.systemd.enable = true;
  boot.initrd.luks.devices."cryptroot".preLVM = true;

  # Audio codec power management (saves ~0.5-1W)
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=1
    options snd_ac97_codec power_save=1
  '';

  # Enable runtime PM for all PCI devices by default
  services.udev.extraRules = ''
    # Enable runtime PM for PCI devices (WiFi, Ethernet, NVMe, etc.)
    ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"

    # Enable runtime PM for USB devices (except input devices to avoid lag)
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", ATTR{power/control}="on"
  '';
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.xterm.enable = false;
    windowManager.bspwm = {
      enable = true;
    };
    displayManager = {
      defaultSession = "none+bspwm";
      lightdm.enable = true;
    };
  };

  boot.blacklistedKernelModules = [
    "nouveau"
    "amdgpu"
    "radeon"
  ];

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  # Bind the modesetting driver to the Intel iGPU and disable glamor.
  # glamor's EGL init gets dispatched to NVIDIA's GBM external-platform
  # library (libnvidia-egl-gbm) and segfaults on the Intel GBM device.
  # AccelMethod "none" removes that path; bspwm needs no 2D accel and
  # GL apps still run via nvidia-offload with their own EGL/GLX.
  services.xserver.deviceSection = ''
    BusID "PCI:0:2:0"
    Option "AccelMethod" "none"
  '';

  environment.systemPackages = [ nvidia-offload ];
  hardware.nvidia = {
    # Modesetting is required.
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true; # Critical: enables runtime PM
    open = false;
    nvidiaSettings = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.cpu.intel.updateMicrocode = true;
}
