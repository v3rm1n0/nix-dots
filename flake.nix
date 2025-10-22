{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:FKouhai/helium2nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        Laptop = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
          }
          // inputs;
          modules = [
            ./.
            ./hosts/Laptop
          ];
        };
        Desktop = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
          }
          // inputs;
          modules = [
            ./.
            ./hosts/Desktop
          ];
        };
      };
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
