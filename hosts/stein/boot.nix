{
  pkgs,
  config,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
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
  boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "vfio" "vfio_iommu_type1" "vfio_pci" "nvidia"];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;
  services.xserver = {
    enable = true;
    layout = "us";
    libinput = {
      enable = enable;
    };

    synaptics.enable = true;
    desktopManager.xterm.enable = false;
    windowManager.bspwm = {
      enable = true;
    };
    displayManager = {
      defaultSession = "none+bspwm";
      lightdm.enable = true;
    };
  };

  boot.kernelParams = ["i1915.force_probe=a7a8"];
  boot.blacklistedKernelModules = ["nouveau" "nvidiafb"];

  services.xserver.videoDrivers = ["nvidia"];
  environment.systemPackages = [nvidia-offload];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
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
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
  };
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [intel-media-driver vaapiIntel vaapiVdpau libvdpau-va-gl];

  hardware.cpu.intel.updateMicrocode = true;
}
