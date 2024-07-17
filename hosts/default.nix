{
  lib,
  pipewire-screenaudio,
  disko,
  home-manager,
  impermanence,
  nur,
  agenix,
  nixpkgs-unstable,
  ...
}: let
  unstableOverlay = final: prev: {
    unstable = nixpkgs-unstable.legacyPackages.${prev.system};
  };
  unstableModule = {
    config,
    pkgs,
    ...
  }: {nixpkgs.overlays = [unstableOverlay];};
 pipewire-screenaudio-overlay = final: prev: {
    pipewire-sa = pipewire-screenaudio.packages.${prev.system}.default;
  };
in {
  chunchumaru = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence agenix;};
    modules = [
      {nixpkgs.overlays = [pipewire-screenaudio-overlay];}
      {
        nixpkgs.config.allowUnfreePredicate = _: true;
      }
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      unstableModule
      ./chunchumaru
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [nur.overlay unstableOverlay];
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
