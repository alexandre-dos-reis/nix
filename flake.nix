{ 
  description = "My main configuration";

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-23.11";
      home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs"; # Tell home-manager to follow nix release
      };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      makeOs = lib.nixosSystem;
      makeHome = home-manager.lib.homeManagerConfiguration;
    in {
      # system-wide configuration :
      nixosConfigurations = {
        # all machines are list here named by their hostname:
        white = makeOs {
          inherit system;
          modules = [ ./hosts/white/configuration.nix ];
        };
      };
      # Per user home-manager configuration :
      homeConfigurations = {
        # all users are list here:
        alex = makeHome {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
