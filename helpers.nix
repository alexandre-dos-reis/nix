{
  inputs,
  outputs,
  vars,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  lib = nixpkgs.lib // inputs.home-manager.lib;
  pkgs = nixpkgs.legacyPackages;
  utils = {
    inherit (pkgs.stdenv) isLinux isDarwin;
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
  mkFormatter = forSystems (s: pkgs.${s}.alejandra);

  mkNixos = hosts: lib.genAttrs hosts (host:
        lib.nixosSystem {
          specialArgs = {inherit inputs outputs vars utils;};
          modules = [./hosts/nixos/${host}];
        }
      );

  mkDarwin = hosts: lib.genAttrs hosts (host:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {inherit inputs outputs vars utils;};
          modules = [./hosts/darwin/${host}];
        }
      );

 # TODO: Rearrange for concise
 mkHome = username: system:
    lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {inherit inputs outputs vars utils;};
      modules = [./home/${username}];
    };
}
