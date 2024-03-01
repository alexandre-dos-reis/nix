{
  description = "My config";

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    pkgs = nixpkgs.legacyPackages;
    vars = (import ./vars.nix) pkgs;
    currentWorkingSystem = "aarch64-darwin";
  in {
    formatter.${currentWorkingSystem} = pkgs.${currentWorkingSystem}.alejandra;

    # for NixOs
    nixosConfigurations = {
      ${vars.machines.white.name} = lib.nixosSystem {
        specialArgs = {inherit inputs outputs vars;};
        modules = [
          ./hosts/nixos/${vars.machines.work.name}
        ];
      };
    };

    # For other linux OS
    homeConfigurations = {
      "${vars.username}@${vars.machines.work.name}" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs vars;};
        modules = [./home/${vars.username}];
      };
    };

    # For MacOsx
    darwinConfigurations = {
      ${vars.machines.mbp2012.name} = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs vars;};
        modules = [./hosts/darwin/${vars.machines.mbp2012.name}];
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
