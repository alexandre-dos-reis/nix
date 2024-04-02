{
  inputs,
  vars,
  outputs,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  pkgs = nixpkgs.legacyPackages;
  inherit (vars) username;
  systems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forSystems = nixpkgs.lib.genAttrs systems;

  mkUtils = pkgs: let
    inherit (pkgs.stdenv) isLinux isDarwin;
    isNixOs = builtins.pathExists /etc/nixos;
  in {
    ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
    inherit isLinux isDarwin isNixOs;
    isOtherLinuxOs = !isNixOs && isLinux;
  };

  mkExtendedVars = {vars, utils}: vars // {
    homeDirectory = if utils.isDarwin then "/Users/${vars.username}" else "/home/${vars.username}";
  };

in {
  mkFormatter = forSystems (s: pkgs.${s}.alejandra);

  mkNixos = host: let 
    utils = mkUtils pkgs;
  in
    nixpkgs.lib.nixosSystem {
      system = host.system;
      specialArgs = {inherit inputs outputs vars host utils;};
      modules = [
        ./hosts/nixos/${host.folder}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username}.imports = [./home/${username}];
          home-manager.extraSpecialArgs = {
            inherit inputs outputs host utils;
            vars = mkExtendedVars {inherit vars utils;};
          };
        }
      ];
    };

  mkDarwin = host: let 
    utils = mkUtils pkgs;
  in
    inputs.nix-darwin.lib.darwinSystem {
      system = host.system;
      specialArgs = {inherit inputs outputs vars host utils;};
      modules = [
        ./hosts/darwin/${host.folder}
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username}.imports = [./home/${username}];
          home-manager.extraSpecialArgs = {
            inherit inputs outputs host utils;
            vars = mkExtendedVars {inherit vars utils;};
          };
        }
      ];
    };

  mkHome = username: host: let
    pkgs = import inputs.nixpkgs {
      system = host.system;
      overlays = [inputs.nixgl.overlay];
    };
    utils = mkUtils pkgs;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home/${username}];
      extraSpecialArgs = {
        inherit inputs outputs host utils;
        vars = mkExtendedVars {inherit vars utils;};
      };
    };
}
