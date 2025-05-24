{
  lib,
  disko,
  deepcool,
  home-manager,
  impermanence,
  nur,
  agenix,
  nixpkgs-unstable,
  nixpkgs,
  ...
}:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  unstableOverlay = final: prev: { unstable = pkgs-unstable; };
in
{
  chunchumaru =
    let
      pkgs-legacy = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      legacyOverlay = final: prev: { legacy = pkgs-legacy; };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          unstableOverlay
          legacyOverlay
        ];
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in
    lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        inherit impermanence agenix;
      };
      modules = [
        impermanence.nixosModules.impermanence
        disko.nixosModules.disko
        nur.modules.nixos.default
        agenix.nixosModules.default
        deepcool.packages.${system}.nixosModule
        home-manager.nixosModules.home-manager
        ./chunchumaru
        { imports = [ ../modules/kvmfr.nix ]; }
        {
          nixpkgs.overlays = [
            nur.overlays.default
            unstableOverlay
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.rustysnek = import ../users/rustysnek;
          home-manager.extraSpecialArgs = {
            inherit impermanence;
          };
        }
      ];
    };
}
