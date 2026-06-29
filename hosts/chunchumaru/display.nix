{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.xterm.enable = false;
    windowManager.bspwm.enable = true;
    displayManager.lightdm.enable = true;
  };
  services.displayManager = {
    defaultSession = "none+bspwm";
  };
  services.libinput = {
    enable = false;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.cpu.amd.updateMicrocode = true;
}
