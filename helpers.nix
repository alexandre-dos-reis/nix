{
  inputs,
  vars,
  outputs,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  forSystems = nixpkgs.lib.genAttrs (import ./constants.nix).systems;

  mkUtils = host: {
    isDarwin = host.os == "darwin";
    isLinux = host.os == "linux";
    system = "${host.arch}-${host.os}";
    ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
  };

  mkExtendedVars = {
    vars,
    utils,
  }:
    vars
    // {
      homeDirectory =
        if utils.isDarwin
        then "/Users/${vars.username}"
        else "/home/${vars.username}";
    };

  globalOverlays = [
    inputs.neovim-nightly-overlay.overlay
  ];
in {
  mkFormatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);

  mkHome = username: host: let
    utils = mkUtils host;
    extraSpecialArgs = {
      inherit inputs outputs host utils;
      vars = mkExtendedVars {inherit vars utils;};
      isManagedByHomeManager = true;
    };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = utils.system;
        overlays =
          globalOverlays
          ++ (
            if utils.isLinux
            then [inputs.nixgl.overlay]
            else []
          );
      };
      modules = [./home/${username}];
      inherit extraSpecialArgs;
    };

  mkNixos = host: let
    utils = mkUtils host;
    specialArgs = {
      inherit inputs outputs host utils;
      vars = mkExtendedVars {inherit vars utils;};
      isManagedByHomeManager = false;
    };
  in
    nixpkgs.lib.nixosSystem {
      system = utils.system;
      inherit specialArgs;
      modules = [
        ./hosts/nixos/${host.folder}
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
      inherit inputs outputs host utils;
      vars = mkExtendedVars {inherit vars utils;};
      isManagedByHomeManager = false;
    };
  in
    inputs.nix-darwin.lib.darwinSystem {
      system = utils.system;
      inherit specialArgs;
      modules = [
        ./hosts/darwin/${host.folder}
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
