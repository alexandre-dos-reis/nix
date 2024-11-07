{
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
} @ inputs: let
  outputs = self.outputs;

  decorateHost = args:
    {
      overlays = [];
      isNixGlWrapped = false;
      xdgDataFileEnabled = false;
      isManagedByHomeManager = false;
      users = [];
    }
    // args;

  mkPkgs = host:
    import nixpkgs {
      system = "${host.arch}-${host.os}";
      overlays = host.overlays;
    };

  mkUtils = pkgs: {inherit (pkgs.stdenv) isDarwin isLinux;};

  decorateUser = user: utils:
    user
    // {
      homeDir =
        if utils.isDarwin
        then "/Users/${user.username}"
        else "/home/${user.username}";
    };

  mkHomes = list:
    builtins.listToAttrs (nixpkgs.lib.lists.flatten (map (host: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = let
          pkgs = mkPkgs host;
          utils = mkUtils pkgs;
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs outputs host utils;
              user = decorateUser user utils;
            };
            modules = [./home/${user.username}];
          };
      })
      host.users))
    list));

  mkSystems = mkSystem: list:
    builtins.listToAttrs (map (host: {
        name = host.hostname;
        value = let
          pkgs = mkPkgs host;
          utils = mkUtils pkgs;
        in
          mkSystem {
            inherit pkgs;
            specialArgs = {
              inherit inputs outputs host utils;
              users = host.users;
            };
            modules = [
              ./hosts/${host.os}/${host.hostname}
            ];
          };
      })
      list);
in {
  mkFlake = rawHosts: let
    hosts = map (x: decorateHost x) rawHosts;
    filterHostsByOs = os: builtins.filter (host: host.os == os && !host.isManagedByHomeManager) hosts;
  in {
    nixosConfigurations = mkSystems nixpkgs.lib.nixosSystem (filterHostsByOs "linux");
    darwinConfigurations = mkSystems nix-darwin.lib.darwin (filterHostsByOs "darwin");
    homeConfigurations = mkHomes hosts;
  };
}
