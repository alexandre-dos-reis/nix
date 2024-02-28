{ 
  description = "My configuration flake";

  outputs = { self, nixpkgs, ... } @ inputs: let
    inherit (self) outputs;

    globals = {
      username = "alex";
      email = "ajm.dosreis.daponte@gmail.com";
      };

  in {
    nixosConfigurations = {
      white = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs globals;};
        modules = [
          ./hosts/white
        ];
      };
    };
  };

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-unstable";
  };
}
