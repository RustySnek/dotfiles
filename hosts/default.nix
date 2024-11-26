{
  lib,
  pipewire-screenaudio,
  disko,
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
      pipewire-screenaudio-overlay = final: prev: {
        pipewire-sa = pipewire-screenaudio.packages.${prev.system}.default;
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          unstableOverlay
          pipewire-screenaudio-overlay
        ];
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };

    in
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit impermanence agenix;
        pkgs = pkgs;
      };
      modules = [
        impermanence.nixosModules.impermanence
        disko.nixosModules.disko
        nur.nixosModules.nur
        agenix.nixosModules.default
        ./chunchumaru
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [
            nur.overlay
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
