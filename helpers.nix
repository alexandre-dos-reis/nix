{
  inputs,
  outputs,
  vars,
  ...
}: let
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
  nixpkgs = inputs.nixpkgs;
  stdenv = nixpkgs.legacyPackages.stdenv;
  utils = {
    isLinux = stdenv.isLinux;
    isDarwin = stdenv.isDarwin;
    isNixOs = builtins.pathExists /etc/nixos;
  };
  allSystems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forAllSystems = lib.genAttrs allSystems;
in {
  mkFormatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

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

  mkHome = module: pkgs:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs outputs vars utils;};
      modules = [module];
    };
}
