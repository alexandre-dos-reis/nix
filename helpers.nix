{
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
} @ inputs: let
  outputs = self.outputs;

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
    # ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
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
          home-manager.lib.homeManagerConfiguration {
            pkgs = mkPkgs {inherit utils host;};
            extraSpecialArgs = {inherit inputs outputs host utils user;};
            modules = [./home/${user.username}];
          };
      })
      users))
    list));

  mkSystems = dir: os: func: list:
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
              ./hosts/${dir}/${host.path}
            ];
          };
      })
      (builtins.filter ({host, ...}: host.os == os) list));
in {
  mkHost = args:
    {
      overlays = [];
      isNixGlWrapped = false;
      xdgDataFileEnabled = false;
      isManagedByHomeManager = false;
    }
    // args;

  mkFlake = list: {
    nixosConfigurations = mkSystems "nixos" "linux" nixpkgs.lib.nixosSystem list;
    darwinConfigurations = mkSystems "darwin" "darwin" nix-darwin.lib.darwin list;
    homeConfigurations = mkHomes list;
  };
}
