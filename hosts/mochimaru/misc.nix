{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    xdg-utils
    glib
  ];
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  security.polkit.enable = true;
}
