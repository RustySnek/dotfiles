{
  lib,
  disko,
  home-manager,
  impermanence,
  nur,
  devenv,
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
  stein = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence devenv agenix;};
    modules = [
      {
        nixpkgs.config.allowUnfreePredicate = _: true;
      }
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      unstableModule
      ./stein
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [nur.overlay unstableOverlay];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.poro = import ../users/poro;
        home-manager.extraSpecialArgs = {
          inherit impermanence;
        };
      }
    ];
  };
}
