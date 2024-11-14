{
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
  ...
} @ inputs: let
  outputs = self.outputs;
  hasSuffix = nixpkgs.lib.strings.hasSuffix;
  flattenList = nixpkgs.lib.lists.flatten;
  listToAttrs = builtins.listToAttrs;

  decorateHost = args:
    {
      overlays = [];
      isNixGlWrapped = false;
      xdgDataFileEnabled = false;
      isManagedByHomeManager = false;
      users = [];
    }
    // args;

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
    listToAttrs (flattenList (map (host: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = let
          pkgs = nixpkgs.legacyPackages.${host.system};
          utils = mkUtils pkgs;
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs outputs host utils;
              user = decorateUser user utils;
            };
            modules = [
              {
                nixpkgs.overlays = (
                  if host.isNixGlWrapped
                  then [inputs.nixgl.overlay]
                  else []
                );
              }
              ./home/${user.username}
            ];
          };
      })
      host.users))
    list));

  mkSystems = mkSystem: list: dir:
    listToAttrs (map (host: {
        name = host.hostname;
        value = let
          pkgs = import nixpkgs {
            system = host.system;
            overlays = host.overlays;
          };
          utils = mkUtils pkgs;
        in
          mkSystem {
            inherit pkgs;
            specialArgs = {
              inherit inputs outputs host utils;
              users = host.users;
            };
            modules = [
              ./hosts/${dir}/${host.hostname}
            ];
          };
      })
      list);
in
  hosts: let
    decoratedHosts = map (x: decorateHost x) hosts;
    filterHostsByOs = os: builtins.filter (host: (hasSuffix os host.system) && !host.isManagedByHomeManager) decoratedHosts;
  in {
    nixosConfigurations = mkSystems nixpkgs.lib.nixosSystem (filterHostsByOs "linux") "nixos";
    darwinConfigurations = mkSystems nix-darwin.lib.darwin (filterHostsByOs "darwin") "darwin";
    homeConfigurations = mkHomes decoratedHosts;
  }
