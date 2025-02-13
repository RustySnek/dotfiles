{
  inputs = {
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    deepcool.url = "github:RustySnek/deepcool-digital-linux/nix";
    roxy.url = "github:RustySnek/roxy";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/NUR";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-legacy,
      pipewire-screenaudio,
      home-manager,
      impermanence,
      disko,
      nur,
      deepcool,
      roxy,
      agenix,
      ...
    }:
    let
      user = "rustysnek";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit
            pipewire-screenaudio
            inputs
            nixpkgs
            deepcool
            roxy
            nixpkgs-unstable
            nixpkgs-legacy
            home-manager
            impermanence
            disko
            user
            nur
            agenix
            ;
        }
      );
    };
}
