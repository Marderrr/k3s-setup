{
  description = "K3s NixOS Flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs: let
    nodes = [
      "kepler-1"
      "kepler-2"
      "kepler-3"
    ];
  in {
    nixosConfigurations = builtins.listToAttrs (map (name: {
      name = name;
      value = nixpkgs.lib.nixosSystem {
        specialArgs = {
          meta = { hostname = name; };
        };
        modules = [
          disko.nixosModules.disko
          ./hardware-configuration.nix
          ./disko-config.nix
	  ./configuration.nix
        ];
      };
    }) nodes);
  };
}
