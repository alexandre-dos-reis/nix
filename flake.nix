{ 
  description = "My config";

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    pkgs = nixpkgs.legacyPackages;

    globals = {
      username = "alex";
      email = "ajm.dosreis.daponte@gmail.com";
      fullname = "Alexandre Dos Reis";
      machines = {
        white.name = "white";
        work.name = "kavval";
        mbp2012.name = "mbp2012";
      };
      utils = {
        isLinux = pkgs.stdenv.isLinux;
        isDarwin = pkgs.stdenv.isDarwin;
        isNixOs = builtins.pathExists /etc/nixos;
      };
    };

  in {
    # for NixOs
    nixosConfigurations = {
      "${globals.machine.white.name}" = lib.nixosSystem {
        specialArgs = {inherit inputs outputs globals;};
        modules = [
          # TODO: import home-manager inside nixos where home config is ready !
          ./hosts/nixos/${globals.machine.white.name}
        ];
      };
    };

    # For other linux OS
    homeConfigurations = {
      "${globals.username}@${globals.machines.work.name}" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs globals; };
          modules = [ ./home/${globals.username} ];
      };
    };

    # For MacOsx
    darwinConfigurations = {
      "${globals.machine.mbp2012.name}" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs outputs globals; };
        modules = [ ./hosts/darwin/${globals.machines.mbp2012.name} ];
      };
    };
  };

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-unstable";
      nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
