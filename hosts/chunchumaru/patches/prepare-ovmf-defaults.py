"""Prepare raw host defaults and explicit enrollment tooling in an EDK2 tree.

Run by the Nix build, not against host or guest NVRAM. Source anchors and
snapshot hashes fail closed when inputs drift. No certificates are rewritten.
"""

import hashlib
import json
from pathlib import Path
import shutil
import struct
import sys


snapshot = Path(sys.argv[1])
module_source = Path(sys.argv[2])
target = Path("OvmfPkg/HostSecureBoot")
manifest = json.loads((snapshot / "manifest.json").read_text())
target.mkdir()
for source in module_source.iterdir():
    shutil.copyfile(source, target / source.name)

# Ordering is shared with HostEnrollDefaults.c: PK must be enrolled last.
names = ["db", "dbx", "KEK", "PK"]
header = ["// Generated from byte-preserved public host signature lists.\n"]
for name in names:
    default = name + "Default"
    data = (snapshot / (default + ".esl")).read_bytes()
    if hashlib.sha256(data).hexdigest() != manifest["variables"][default]["sha256"]:
        raise SystemExit(f"Snapshot hash mismatch: {default}")
    if not data:
        raise SystemExit(f"Empty default database: {default}")
    for marker in ("red hat", "redhat", "qemu"):
        for encoding in ("ascii", "utf-16-le"):
            if marker.encode(encoding) in data.lower():
                raise SystemExit(f"Marker in {default}; replace the source certificate, never strip bytes")
    offset = 0
    while offset < len(data):
        if len(data) - offset < 28:
            raise SystemExit(f"Truncated signature list: {default}")
        size, extra, signature = struct.unpack_from("<III", data, offset + 16)
        if (size < 28 + extra or signature < 16 or
                (size - 28 - extra) % signature or offset + size > len(data)):
            raise SystemExit(f"Invalid signature list: {default}")
        offset += size
    header.append(f"STATIC UINT8 m{name}Default[] = {{\n")
    for start in range(0, len(data), 16):
        header.append("  " + ", ".join(f"0x{b:02x}" for b in data[start:start + 16]) + ",\n")
    header.append("};\n")

header.append("STATIC HOST_DEFAULT mHostDefaults[] = {\n")
for name in names:
    guid = "gEfiImageSecurityDatabaseGuid" if name in ("db", "dbx") else "gEfiGlobalVariableGuid"
    header.append(f'  {{ L"{name}Default", L"{name}", &{guid}, m{name}Default, sizeof (m{name}Default) }},\n')
header.append("};\n")
(target / "HostDefaultData.h").write_text("".join(header))


def insert_after(filename, anchor, addition):
    path = Path(filename)
    source = path.read_bytes()
    newline = b"\r\n" if b"\r\n" in source else b"\n"
    old = anchor.encode() + newline
    if source.count(old) != 1:
        raise SystemExit(f"Expected one source anchor in {filename}: {anchor}")
    new = old + addition.replace("\n", newline.decode()).encode()
    path.write_bytes(source.replace(old, new))


insert_after(
    "OvmfPkg/OvmfPkgX64.dsc",
    "  SecurityPkg/VariableAuthenticated/SecureBootConfigDxe/SecureBootConfigDxe.inf",
    "  OvmfPkg/HostSecureBoot/HostDefaultsDxe.inf\n"
    "  OvmfPkg/HostSecureBoot/HostEnrollDefaults.inf\n",
)
insert_after(
    "OvmfPkg/OvmfPkgX64.fdf",
    "  INF  SecurityPkg/VariableAuthenticated/SecureBootConfigDxe/SecureBootConfigDxe.inf",
    "  INF  OvmfPkg/HostSecureBoot/HostDefaultsDxe.inf\n",
)
# Enrollment is compiled as an application but never dispatched by firmware.
