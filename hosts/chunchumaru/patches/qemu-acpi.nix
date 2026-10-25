{ lib, qemu, firmware, oemId, oemTableId }:
assert builtins.stringLength oemId == 6;
assert builtins.stringLength oemTableId <= 8;
let
  # Preserve the host's trailing NUL bytes as C octal escapes, not JSON \u0000.
  tableIdLiteral =
    lib.removeSuffix "\"" (builtins.toJSON oemTableId)
    + lib.concatStrings (builtins.genList (_: "\\000") (8 - builtins.stringLength oemTableId))
    + "\"";
in
qemu.overrideAttrs (old: {
  # This package is selected only by the shared boot.nix patch switch.
  patches = (old.patches or [ ]) ++ [
    ./qemu-smbios.patch
    ./qemu-pci-default-subsystem.patch
    ./qemu-fw-cfg-acpi.patch
    ./qemu-acpi-debug.patch
    ./qemu-acpi-resources.patch
    ./qemu-acpi-routing-names.patch
    ./qemu-acpi-hpet-status.patch
    ./qemu-acpi-pirq-names.patch
    ./qemu-acpi-irq-query-names.patch
    ./qemu-acpi-firmware-shapes.patch
    ./qemu-acpi-cstate-latencies.patch
    ./qemu-acpi-irq5-option.patch
    ./qemu-acpi-waet-option.patch
    ./qemu-kvm-strict-instruction-faults.patch
    ./qemu-acpi-pit-device.patch
    ./qemu-kvm-native-cpuid.patch
    ./qemu-kvm-skip-db-intercept.patch
  ];
  # Keep the existing libvirt firmware paths and 4 MiB pflash layout.
  # Replace bundled x86_64 Secure Boot firmware only; never touch VM NVRAM.
  postInstall = (old.postInstall or "") + ''
    test "$(stat -Lc %s ${firmware.fd}/FV/OVMF_CODE.fd)" = 3653632
    test "$(stat -Lc %s ${firmware.fd}/FV/OVMF_VARS.fd)" = 540672
    ln -sfn ${firmware.fd}/FV/OVMF_CODE.fd "$out/share/qemu/edk2-x86_64-secure-code.fd"
    ln -sfn ${firmware.fd}/FV/OVMF_VARS.fd "$out/share/qemu/edk2-i386-vars.fd"
    ln -sfn ${firmware.fd}/Applications/HostEnrollDefaults.efi \
      "$out/share/qemu/HostEnrollDefaults.efi"
  '';
  # Patch shared defaults used by x86 machine ACPI builders, including DSDT.
  # Fail on source drift rather than silently leaving the stock identifiers.
  postPatch = (old.postPatch or "") + ''
    substituteInPlace include/hw/acpi/aml-build.h \
      --replace-fail ${lib.escapeShellArg ''#define ACPI_BUILD_APPNAME6 "BOCHS "''} \
        ${lib.escapeShellArg ("#define ACPI_BUILD_APPNAME6 " + builtins.toJSON oemId)} \
      --replace-fail ${lib.escapeShellArg ''#define ACPI_BUILD_APPNAME8 "BXPC    "''} \
        ${lib.escapeShellArg ("#define ACPI_BUILD_APPNAME8 " + tableIdLiteral)}
  '';
})
