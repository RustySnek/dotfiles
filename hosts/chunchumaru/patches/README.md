# Custom KVM, QEMU and OVMF patches

## Configuration

`enableCustomKvmPatches` in `../boot.nix` controls the kernel patches,
custom QEMU and OVMF builds, and the `kvm.ignore_msrs=1` and
`kvm.report_ignored_msrs=0` kernel parameters. The same value is passed to
`../libvirt.nix` as `customVmPatchesEnabled`.

Build the desired NixOS configuration from the repository root, replacing
`HOST` with its flake configuration name:

```sh
sudo nixos-rebuild boot --flake .#HOST
sudo reboot
```

Kernel changes require a host reboot. QEMU and firmware changes require a
full VM stop/start. Explicit emulator paths in saved libvirt definitions
can pin an older build; check them after rebuilding. Disabling the switch
does not revert saved VM XML settings or persistent NVRAM changes.

## Kernel patches

The patches target zen-kernel `v7.2.7-zen1` and apply in the order listed
in `../boot.nix`.

- `kvm-wall-clock-msr.patch`: unsupported guest accesses to
  `MSR_KVM_WALL_CLOCK` and `MSR_KVM_WALL_CLOCK_NEW` return zero on reads
  and discard writes. Supported accesses and host-initiated accesses keep
  their original behavior. This affects all VMs using the patched kernel.
  The blanket `ignore_msrs` option also affects other unsupported MSRs.
- `kvm-strict-instruction-faults.patch`: changes user-mode hypercall and
  SVM instruction faults for VMs that disable the legacy
  `KVM_X86_QUIRK_FIX_HYPERCALL_INSN` quirk.
- `kvm-native-cpuid.patch`: adds an experimental AMD capability to execute
  raw host CPUID without interception. It defaults off. Raw results can
  disagree with configured guest features, topology and APIC IDs.
- `kvm-skip-db-intercept.patch`: adds an experimental AMD capability to
  skip routine guest #DB interception. It defaults off and re-arms the
  intercept for KVM single-stepping and guest debugging. Opting in removes
  the routine interception used for the CVE-2015-8104 mitigation; use only
  with trusted guests.
- `kvm-icebp.patch`: backports upstream commit
  [ec9a16c6aeba](https://github.com/torvalds/linux/commit/ec9a16c6aeba),
  advancing RIP at the ICEBP instruction intercept before injecting #DB.
  It is independent of the optional #DB interception experiment.

`tests/icebp-rip.c` is an isolated KVM regression probe. It checks the saved
instruction pointer after ICEBP with warm and cold second-level stack
mappings. It creates a small guest and does not access VM disks.

## QEMU patches

The patches target QEMU `v10.2.4`; `qemu-acpi.nix` defines their order.

The ACPI patches change default OEM identifiers, resource identifiers,
IRQ routing names and AML shapes. They omit the fw_cfg discovery node and
DSDT debug port. The underlying fw_cfg interface remains available to
firmware. FADT C2/C3 latencies remain above the thresholds that indicate
unsupported states.

The OEM ID must be six bytes. The OEM table ID is padded to eight bytes
with NULs. The shared `ACPI_BUILD_APPNAME8` macro also supplies the first
four bytes of the creator ID. Explicit table overrides and firmware-owned
tables are not rewritten. Do not substitute physical-machine DSDT/SSDT
files: their hardware descriptions are not interchangeable with a VM's.

`qemu-smbios.patch` selects a desktop chassis and defaults the Type 0 `vm`
option to false. Explicit `type=0,vm=on` overrides that default.

Additional machine properties are opt-in unless otherwise noted:

| Property | Behavior |
| --- | --- |
| `x-pci-irq5-override` | Controls the legacy PCI IRQ5 MADT source override; the initial value follows the existing IRQ mask. |
| `x-waet` | Controls inclusion of WAET; defaults on. |
| `x-strict-instruction-faults` | Disables KVM's legacy hypercall instruction-fixing quirk; defaults off. |
| `x-acpi-pit-device` | Declares the existing PIT as an ACPI PNP0100 device; defaults off. |
| `x-native-cpuid` | Requests raw AMD CPUID through the matching kernel capability; defaults off. |
| `x-skip-db-intercept` | Requests the matching AMD #DB capability; defaults off. |

`qemu-pci-default-subsystem.patch` adds the PCI device property
`x-default-subsystem-id`, which defaults on. Turning it off leaves
unspecified subsystem IDs zero; explicit device IDs are unaffected.
Changing PCI identities may affect guest driver matching. In particular,
Looking Glass requires a matching IVSHMEM driver.

These changes do not guarantee that a VM is undetectable. Runtime checks
must cover guest boot, device operation and the relevant instruction or
firmware behavior, not just detector scores.

## Firmware and Secure Boot

`ovmf.nix` builds Secure Boot and TPM support, changes the firmware vendor
string and boot logo, and renames the volatile boot-order hint variables.
It uses `msVarsTemplate = false`. The QEMU override installs this firmware
with a 4 MiB pflash layout: 3,653,632 bytes of code and 540,672 bytes of
variable storage. Existing VM NVRAM is not modified by the build.

`prepare-ovmf-defaults.py` validates the recorded hashes and structure of
the public signature lists in `secure-boot/`, generates C arrays, and adds
the custom modules to the EDK2 DSC/FDF. Signed certificate bytes and
signature-owner metadata are preserved.

`HostDefaultsDxe` publishes PKDefault, KEKDefault, dbDefault and dbxDefault
as volatile boot/runtime variables. Conflicting defaults are reported
rather than overwritten. It does not enroll active keys.

`HostEnrollDefaults.efi` is exposed at `/etc/ovmf/HostEnrollDefaults.efi`.
It must be run deliberately from a UEFI shell. It requires Setup Mode and
an empty active key set, verifies all defaults, enrolls db/dbx/KEK/PK in
that order, and compares the resulting payloads. It attempts to restore
Standard Mode after success or failure. Partial writes remain and require
manual review before retrying.

The NVRAM reset helper in this directory is specific to a local domain.
Review its domain, NVRAM and template paths before use. It requires the VM
to be shut off, backs up the current store and inactive XML, checks size
compatibility, and replaces the store. Resetting NVRAM can remove boot
entries and enrolled keys; preserve a recoverable backup.

See [NVRAM-STATUS.md](NVRAM-STATUS.md) for verification requirements.
The firmware snapshot and boot logo remain separate repository assets;
this documentation does not anonymize their contents.

## Maintaining the patch set

Add kernel patches to the existing conditional list in `../boot.nix` and
QEMU patches to `qemu-acpi.nix`. Keep related overrides under the shared
switch. Check patch order and source anchors when updating dependencies.
New patch files must be tracked for a Git-backed flake to include them.

Source-level checks have confirmed that the kernel and QEMU patch stacks
apply to the versions above with zero fuzz, and that the firmware
preparation script accepts the bundled signature lists. Those checks do
not establish guest runtime correctness or Secure Boot enforcement.
