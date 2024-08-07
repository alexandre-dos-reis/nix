inputs: let
  inherit (inputs) outputs;
  vars = import ./vars.nix;
  nixpkgs = inputs.nixpkgs;
  forSystems = nixpkgs.lib.genAttrs (import ./constants.nix).systems;

  mkPkgs = {
    utils,
    host,
  }:
    import nixpkgs {
      system = utils.system;
      overlays = host.overlays;
    };

  mkUtils = host: {
    system = "${host.arch}-${host.os}";
    ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
    getHomeDir = {
      isDarwin,
      username,
    }:
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";
  };
in {
  mkFormatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);

  mkHome = username: host: let
      utils = mkUtils host;
    in inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs {inherit utils host;};
      modules = [./home/${username}];
      extraSpecialArgs = {inherit inputs outputs host utils vars;};
    };

  mkNixos = host: let
      utils = mkUtils host;
    in nixpkgs.lib.nixosSystem {
      pkgs = mkPkgs {inherit utils host;};
      specialArgs = {inherit inputs outputs host utils vars;};
      modules = [./hosts/nixos/${host.path}];
    };

  mkDarwin = host: let
      utils = mkUtils host;
    in inputs.nix-darwin.lib.darwinSystem {
      pkgs = mkPkgs {inherit utils host;};
      specialArgs = {inherit inputs outputs host utils vars;};
      modules = [./hosts/darwin/${host.path}];
    };
}
