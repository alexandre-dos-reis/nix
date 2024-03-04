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

  mkNixos = hosts:
    builtins.listToAttrs
    (builtins.map
      (host: {
        name = host.hostname;
        value = lib.nixosSystem {
          system = host.system;
          specialArgs = {inherit inputs outputs vars utils;};
          modules = [./hosts/nixos/${host.folder}];
        };
      })
      hosts);

  mkDarwin = hosts:
    builtins.listToAttrs
    (builtins.map
      (host: {
        name = host.hostname;
        value = inputs.nix-darwin.lib.darwinSystem {
          system = host.system;
          specialArgs = {inherit inputs outputs vars utils;};
          modules = [./hosts/nixos/${host.folder}];
        };
      })
      hosts);

  mkHome = hosts:
    builtins.listToAttrs
    (builtins.map
      ({
        username,
        host,
      }: {
        name = "${username}@${host.hostname}";
        value = inputs.nix-darwin.lib.darwinSystem {
          pkgs = pkgs.${host.system};
          extraSpecialArgs = {inherit inputs outputs vars utils;};
          modules = [./hosts/nixos/${host.folder}];
        };
      })
      hosts);
}
