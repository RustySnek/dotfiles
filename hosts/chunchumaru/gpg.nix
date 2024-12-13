{ pkgs, ... }:
{
  programs.gnupg.agent = {
    pinentryPackage = pkgs.pinentry-qt;
    enable = true;
    enableSSHSupport = true;
  };
}
