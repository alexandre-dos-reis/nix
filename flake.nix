{ 
  description = "My main configuration";

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-23.05";
      home-manager = {
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs"; # Tell home-manager to follow nix release
      };
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # system-wide configuration :
      nixosConfigurations = {
        # all machines are list here named by their hostname:
        white = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/white/configuration.nix ];
        };
      };
      # Per user home-manager configuration :
      homeConfigurations = {
        # all users are list here:
        alex = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
