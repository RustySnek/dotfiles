{
  lib,
  disko,
  deepcool,
  home-manager,
  impermanence,
  agenix,
  nixpkgs-unstable,
  nixpkgs,
  ...
}:
let
  system = "x86_64-linux";

  pkgs-unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        unstable = pkgs-unstable;
      })
    ];
  };

  commonModules = hostDir: [
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko
    agenix.nixosModules.default
    deepcool.packages.${system}.nixosModule
    home-manager.nixosModules.home-manager
    hostDir
    { imports = [ ../modules/kvmfr.nix ]; }
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.rustysnek = import ../users/rustysnek;
      home-manager.extraSpecialArgs = {
        inherit impermanence;
      };
    }
  ];

  mkHost =
    hostDir:
    lib.nixosSystem {
      inherit pkgs system;
      specialArgs = {
        inherit impermanence agenix;
      };
      modules = commonModules hostDir;
    };
in
{
  chunchumaru = mkHost ./chunchumaru;
}
