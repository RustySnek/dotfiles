{ pkgs, config, ... }:
{
  virtualisation.libvirtd.onBoot = "start";
  systemd.services.libvirtd.preStart =
    let
      qemuHook = pkgs.writeScript "qemu-hook" ''
        #!${pkgs.stdenv.shell}
        GUEST_NAME="$1"
        OPERATION="$2"
        SUB_OPERATION="$3"
        if [[ "$GUEST_NAME" == "win11"* ]]; then
          if [[ "$OPERATION" == "started" ]]; then
            systemctl set-property --runtime -- user.slice AllowedCPUs=0,8
            systemctl set-property --runtime -- system.slice AllowedCPUs=0,8
            systemctl set-property --runtime -- init.scope AllowedCPUs=0,8
          fi
          if [[ "$OPERATION" == "stopped" ]]; then
            systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
          fi
        fi
      '';
    in
    ''
      # mkdir -p /var/lib/libvirt/hooks
      # chmod 755 /var/lib/libvirt/hooks
      # Copy hook files
      # ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
    '';

  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:1ad9,10de:1ad8,10de:10f8,10de:1e81,0d:00.0
    options snd_hda_intel power_save=0
  '';

  boot.blacklistedKernelModules = [
    "nouveau"
  ];
  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 root libvirtd -" ];
  environment.systemPackages = with pkgs; [
    virt-manager
    looking-glass-client
    qemu
    unstable.OVMFFull
    pciutils
    swtpm
    win-virtio
    quickemu
  ];

  boot.kernel.sysctl = {
    "vm.nr_overcommit_hugepages" = 16384;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
    ovmf.enable = true;
    ovmf.packages = [ pkgs.unstable.OVMFFull.fd ];
    runAsRoot = false;
    package = pkgs.qemu_kvm;
  };
  virtualisation.kvmfr = {
    enable = true;
    shm = {
      enable = true;
      size = 128;
      user = "rustysnek";
      group = "libvirtd";
      mode = "0666";
    };
  };
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio", "/dev/looking-glass"
    ]
  '';
}
