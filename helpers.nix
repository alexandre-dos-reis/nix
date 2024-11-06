{
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
} @ inputs: let
  outputs = self.outputs;

  mkHost = args:
    {
      overlays = [];
      isNixGlWrapped = false;
      xdgDataFileEnabled = false;
      isManagedByHomeManager = false;
      users = [];
    }
    // args;

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
    builtins.listToAttrs (nixpkgs.lib.lists.flatten (map (host: (map (user: {
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
      host.users))
    list));

  mkSystems = system: list:
    builtins.listToAttrs (map (host: {
        name = host.hostname;
        value = let
          utils = mkUtils host;
        in
          system {
            pkgs = mkPkgs {inherit utils host;};
            specialArgs = {
              users = host.users;
              inherit inputs outputs host utils;
            };
            modules = [
              ./hosts/${host.os}/${host.hostname}
            ];
          };
      })
      list);
in {
  mkFlake = rawHosts: let
    hosts = map (x: mkHost x) rawHosts;
    filterHostsByOs = os: builtins.filter (host: host.os == os && !host.isManagedByHomeManager) hosts;
  in {
    nixosConfigurations = mkSystems nixpkgs.lib.nixosSystem (filterHostsByOs "linux");
    darwinConfigurations = mkSystems nix-darwin.lib.darwin (filterHostsByOs "darwin");
    homeConfigurations = mkHomes hosts;
  };
}
