{
  lib,
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
in {
  mochimaru = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence agenix;};
    modules = [
      {
        nixpkgs.config.allowUnfreePredicate = _: true;
      }
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.modules.nixos.default
      agenix.nixosModules.default
      unstableModule
      ./mochimaru
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
