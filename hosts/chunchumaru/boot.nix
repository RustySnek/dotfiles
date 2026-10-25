{ pkgs, config, lib, ... }:
let
  # Toggle all custom KVM/QEMU/OVMF patches and MSR options; see patches/README.md.
  enableCustomKvmPatches = true;
in
{
  # Share the single switch with libvirt.nix for QEMU source patches.
  _module.args.customVmPatchesEnabled = enableCustomKvmPatches;
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
  # Add future custom KVM patches here so the same switch controls them.
  boot.kernelPatches = lib.optionals enableCustomKvmPatches [
    {
      name = "kvm-wall-clock-msr";
      patch = ./patches/kvm-wall-clock-msr.patch;
    }
    {
      name = "kvm-strict-instruction-faults";
      patch = ./patches/kvm-strict-instruction-faults.patch;
    }
    {
      name = "kvm-native-cpuid";
      patch = ./patches/kvm-native-cpuid.patch;
    }
    {
      name = "kvm-skip-db-intercept";
      patch = ./patches/kvm-skip-db-intercept.patch;
    }
    {
      name = "kvm-icebp";
      patch = ./patches/kvm-icebp.patch;
    }
  ];
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
  boot.kernelParams =
    [
      "amd_iommu=on"
      "iommu=pt"
    ]
    ++ lib.optionals enableCustomKvmPatches [
      # Keep options associated with custom KVM patches behind the same switch.
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
    ];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot-backup".preLVM = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
}
