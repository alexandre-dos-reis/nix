inputs: let
  inherit (inputs) outputs nixpkgs nix-darwin;
  inherit (import ./constants.nix) linux darwin;
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

  mkHomes = list:
    builtins.listToAttrs (nixpkgs.lib.lists.flatten (map ({
      users,
      host,
    }: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = let
          utils = mkUtils host;
        in
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = mkPkgs {inherit utils host;};
            extraSpecialArgs = {inherit inputs outputs host utils user;};
            modules = [./home/${user.username}];
          };
      })
      users))
    list));

  mkOsSystems = folder: os: func: list:
    builtins.listToAttrs (map ({
        host,
        users,
      }: {
        name = host.hostname;
        value = let
          utils = mkUtils host;
        in
          func {
            pkgs = mkPkgs {inherit utils host;};
            specialArgs = {inherit inputs outputs host utils users;};
            modules = [
              ./hosts/${folder}/${host.path}
            ];
          };
      })
      (builtins.filter ({host, ...}: host.os == os) list));
in {
  users = import ./users.nix;
  hosts = import ./hosts.nix inputs;
  mkFlake = list: {
    formatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);
    nixosConfigurations = mkOsSystems "nixos" linux nixpkgs.lib.nixosSystem list;
    darwinConfigurations = mkOsSystems "darwin" darwin nix-darwin.lib.darwin list;
    homeConfigurations = mkHomes list;
  };
}
