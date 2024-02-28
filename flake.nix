{ 
  description = "My config";

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    pkgs = nixpkgs.legacyPackages;
    globals = {
      username = "alex";
      email = "ajm.dosreis.daponte@gmail.com";
      machines = {
        white.name = "white";
        work.name = "kavval";
      };
    };

  in {
    nixosConfigurations = {
      "${globals.machine.white.name}" = lib.nixosSystem {
        specialArgs = {inherit inputs outputs globals;};
        modules = [
          # TODO: import home-manager inside nixos where home config is ready !
          ./hosts/${globals.whiteHostName}
        ];
      };
      homeConfigurations = {
        "${globals.username}@${globals.machines.work.name}" = home-manager.lib.homeManagerConfiguration {
            modules = [ ./home/${globals.username} ];
            pkgs = pkgs.x86_64-linux;
            extraSpecialArgs = { inherit inputs outputs globals; };
        };
      };
    };
  };

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-unstable";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
