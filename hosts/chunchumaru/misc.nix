{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-utils
    glib
    dracula-theme
    gnome.adwaita-icon-theme
  ];

  services.dbus.enable = true;
  security.polkit.enable = true;
}
