{ pkgs, ... }:
{
  programs.gpg.enable = true;
  home.packages = with pkgs; [ (pass.withExtensions (ext: with ext; [ pass-otp ])) ];

  home.persistence."/nix/persist/home/rustysnek".directories = [
    ".gnupg"
    ".password-store"
  ];
}
