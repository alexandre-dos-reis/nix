{
  inputs,
  vars,
  outputs,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  forSystems = nixpkgs.lib.genAttrs (import ./constants.nix).systems;
  mkUtils = import ./utils.nix;
in {
  mkFormatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);

  mkHome = username: host: let
    utils = mkUtils host;
    extraSpecialArgs = {
      inherit inputs outputs host utils vars;
      isManagedByHomeManager = true;
    };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = utils.system;
        overlays =
          if host.os == "linux"
          then [inputs.nixgl.overlay]
          else [];
      };
      modules = [./home/${username}];
      inherit extraSpecialArgs;
    };

  mkNixos = host: let
    utils = mkUtils host;
    specialArgs = {
      inherit inputs outputs host utils vars;
      isManagedByHomeManager = false;
    };
  in
    nixpkgs.lib.nixosSystem {
      system = utils.system;
      inherit specialArgs;
      modules = [
        ./hosts/nixos/${host.path}
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${vars.username}.imports = [./home/${vars.username}];
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };

  mkDarwin = host: let
    utils = mkUtils host;
    specialArgs = {
      inherit inputs outputs host utils vars;
      isManagedByHomeManager = false;
    };
  in
    inputs.nix-darwin.lib.darwinSystem {
      system = utils.system;
      inherit specialArgs;
      modules = [
        ./hosts/darwin/${host.path}
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${vars.username}.imports = [./home/${vars.username}];
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };
}
