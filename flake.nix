{ 
  description = "My main configuration";

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    inherit (self) outputs;

    globals = {
      username = "Alex";
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
}
