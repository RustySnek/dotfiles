#!/usr/bin/env bash
set -euo pipefail

# Run as root only after Windows has shut down. The backup stays beside the
# variable store and can be restored before the next boot if needed.
domain=win11-pass-disk
nvram=/var/lib/libvirt/qemu/nvram/win11-pass-disk_VARS.fd
template=/run/libvirt/nix-ovmf/edk2-i386-vars.fd

if (( EUID != 0 )); then
  echo 'Run this script as root.' >&2
  exit 1
fi

state=$(virsh -c qemu:///system domstate "$domain")
if [[ $state != 'shut off' ]]; then
  echo "Refusing to replace NVRAM while $domain is $state." >&2
  exit 1
fi

if [[ ! -f $nvram || ! -f $template ]]; then
  echo 'NVRAM or template file is missing.' >&2
  exit 1
fi

old_size=$(stat -Lc %s "$nvram")
new_size=$(stat -Lc %s "$template")
if [[ $old_size != "$new_size" ]]; then
  echo "NVRAM size $old_size differs from template size $new_size." >&2
  exit 1
fi

backup_dir=$(mktemp -d /var/lib/libvirt/qemu/nvram/win11-pass-disk-backup.XXXXXXXX)
chmod 0700 "$backup_dir"
cp --preserve=all "$nvram" "$backup_dir/win11-pass-disk_VARS.fd"
virsh -c qemu:///system dumpxml --inactive "$domain" > "$backup_dir/domain.xml"
chmod 0600 "$backup_dir/domain.xml"

owner=$(stat -c %u "$nvram")
group=$(stat -c %g "$nvram")
mode=$(stat -c %a "$nvram")
replacement=$(mktemp /var/lib/libvirt/qemu/nvram/win11-pass-disk_VARS.new.XXXXXXXX)
trap 'rm -f "$replacement"' EXIT
install -o "$owner" -g "$group" -m "$mode" "$template" "$replacement"
mv -f "$replacement" "$nvram"
trap - EXIT

echo "NVRAM replaced from $template. Backup: $backup_dir"
