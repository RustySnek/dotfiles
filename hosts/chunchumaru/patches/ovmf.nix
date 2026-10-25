{ OVMF, python3 }:
(OVMF.override {
  secureBoot = true;
  # Defaults are embedded in firmware; active-key enrollment remains explicit.
  msVarsTemplate = false;
  tpmSupport = true;
}).overrideAttrs (old: {
  # Preserve signed certificate bytes and existing active keys.
  postPatch = (old.postPatch or "") + ''
    substituteInPlace MdeModulePkg/MdeModulePkg.dec \
      --replace-fail 'PcdFirmwareVendor|L"EDK II"' \
        'PcdFirmwareVendor|L"American Megatrends International, LLC."'
    # OVMF's volatile boot hints do not need a VMM-prefixed runtime name.
    substituteInPlace OvmfPkg/Library/QemuBootOrderLib/QemuBootOrderLib.c \
      --replace-fail 'L"VMMBootOrder%04x"' 'L"BootHint%04x"'
    test -f MdeModulePkg/Logo/Logo.bmp
    cp ${./host-boot-logo.bmp} MdeModulePkg/Logo/Logo.bmp
    ${python3}/bin/python3 ${./prepare-ovmf-defaults.py} \
      ${./secure-boot} ${./HostSecureBoot}
  '';
  postInstall = (old.postInstall or "") + ''
    install -Dm644 "$out/X64/HostEnrollDefaults.efi" \
      "$fd/Applications/HostEnrollDefaults.efi"
  '';
})
