{
  inputs,
  outputs,
  vars,
  ...
}: let
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
  nixpkgs = inputs.nixpkgs;
  utils = {
    inherit (nixpkgs.legacyPackages.stdenv) isLinux isDarwin;
    isNixOs = builtins.pathExists /etc/nixos;
  };
  systems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forSystems = lib.genAttrs systems;
in {
  mkFormatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);

  mkNixos = module:
    lib.nixosSystem {
      specialArgs = {inherit inputs outputs vars utils;};
      modules = [module];
    };

  mkDarwin = module:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs outputs vars utils;};
      modules = [module];
    };

  mkHome = module: system:
    lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {inherit inputs outputs vars utils;};
      modules = [module];
    };
}
