{
  inputs,
  vars,
  outputs,
  ...
}: let
  inherit (vars) username;
  nixpkgs = inputs.nixpkgs;
  pkgs = nixpkgs.legacyPackages;
  systems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forSystems = nixpkgs.lib.genAttrs systems;

  utils = {
    ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
  };

  globalOverlays = [
    inputs.neovim-nightly-overlay.overlay
  ];

  mkExtendedVars = {
    vars,
    isManagedByHomeManager,
  }:
    vars // {
      inherit isManagedByHomeManager;
    };
in {
  mkFormatter = forSystems (s: pkgs.${s}.alejandra);

  mkHome = username: host:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = host.system;
        overlays = globalOverlays ++ (if host.system == "x86_64-linux" then [inputs.nixgl.overlay] else []);
      };
      modules = [./home/${username}];
      extraSpecialArgs = {
        inherit inputs outputs host utils;
        vars = mkExtendedVars {inherit vars; isManagedByHomeManager = true;};
      };
    };


  # mkNixos = host: let
  #   utils = mkUtils pkgs;
  #   vars = mkExtendedVars {inherit vars utils;};
  # in
  #   nixpkgs.lib.nixosSystem {
  #     system = host.system;
  #     specialArgs = {
  #       inherit inputs outputs host utils vars;
  #     };
  #     modules = [
  #       ./hosts/nixos/${host.folder}
  #       inputs.home-manager.nixosModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.users.${username}.imports = [./home/${username}];
  #         home-manager.extraSpecialArgs = {
  #           inherit inputs outputs host utils vars;
  #         };
  #       }
  #     ];
  #   };
  #
  # mkDarwin = host: let
  #   utils = mkUtils pkgs;
  #   vars = mkExtendedVars {inherit vars utils;};
  # in
  #   inputs.nix-darwin.lib.darwinSystem {
  #     system = host.system;
  #     specialArgs = {
  #       inherit inputs outputs host utils vars;
  #     };
  #     modules = [
  #       ./hosts/darwin/${host.folder}
  #       inputs.home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.users.${username}.imports = [./home/${username}];
  #         home-manager.extraSpecialArgs = {
  #           inherit inputs outputs host utils vars;
  #         };
  #       }
  #     ];
  #   };

}
