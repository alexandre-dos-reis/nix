inputs: let
  inherit (inputs) outputs;
  users = import ./users.nix;
  hosts = (import ./hosts.nix inputs);
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
      user,
    }:
      if isDarwin
      then "/Users/${user.username}"
      else "/home/${user.username}";
  };

  mkHome = user: host: let
    utils = mkUtils host;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs {inherit utils host;};
      extraSpecialArgs = {inherit inputs outputs host utils user;};
      modules = [./home/${user.username}];
    };

  mkNixos = host: let
    utils = mkUtils host;
  in
    nixpkgs.lib.nixosSystem {
      pkgs = mkPkgs {inherit utils host;};
      specialArgs = {inherit inputs outputs host utils users;};
      modules = [./hosts/nixos/${host.path}];
    };

  mkDarwin = host: let
    utils = mkUtils host;
  in
    inputs.nix-darwin.lib.darwinSystem {
      pkgs = mkPkgs {inherit utils host;};
      specialArgs = {inherit inputs outputs host utils users;};
      modules = [./hosts/darwin/${host.path}];
    };

  mkFlake = {
    nixos,
    darwin,
    home,
  }: {
    formatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);

    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host.hostname;
        value = mkNixos host;
      })
      nixos);

    darwinConfigurations = builtins.listToAttrs (map (host: {
        name = host.hostname;
        value = mkDarwin host;
      })
      darwin);

    homeConfigurations = builtins.listToAttrs (nixpkgs.lib.lists.flatten (map ({
      users,
      host,
    }: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = mkHome user host;
      })
      users))
    home));
  };

in {
    inherit mkFlake users hosts;
  }
