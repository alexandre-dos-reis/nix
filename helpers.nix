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
  hasAttr = builtins.hasAttr;
  mkIf = condition: module:
    if condition
    then module
    else {};

  decorateHost = host: let
    isManagedByHomeManager =
      if (hasAttr "isManagedByHomeManager" host)
      then host.isManagedByHomeManager
      else false;
    overlays =
      if (hasAttr "overlays" host)
      then host.overlays
      else [];
    useNixGL = isManagedByHomeManager && host.system == "x86_64-linux";
  in
    host
    // {
      inherit isManagedByHomeManager overlays useNixGL;
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
              (
                mkIf
                (utils.isLinux && host.isManagedByHomeManager)
                ./home/xdg-fix.nix
              )
              (
                mkIf host.useNixGL
                {
                  nixGL.packages = inputs.nixgl.packages;
                }
              )
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
