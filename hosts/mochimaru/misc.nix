{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xdg-utils
    glib
  ];
  services.dbus.enable = true;
  security.polkit.enable = true;
}
