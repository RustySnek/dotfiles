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

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "vfio" "vfio_iommu_type1" "vfio_pci" "nvidia"];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;
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

  boot.blacklistedKernelModules = ["nouveau" "nvidiafb" "amdgpu" "radeon" "intel_agp" "intel_atomisp"];

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

    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.cpu.intel.updateMicrocode = true;
}
 

