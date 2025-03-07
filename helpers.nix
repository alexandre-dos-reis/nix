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

  mkHelpers = pkgs: {inherit (pkgs.stdenv) isDarwin isLinux;};

  decorateUser = user: helpers: let
    modules =
      if (hasAttr "modules" user)
      then user.modules
      else [];
    homeDir =
      if helpers.isDarwin
      then "/Users/${user.username}"
      else "/home/${user.username}";
  in
    user
    // {
      inherit modules homeDir;
    };

  mkHomes = list:
    listToAttrs (flattenList (map (host: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = let
          pkgs = nixpkgs.legacyPackages.${host.system};
          helpers = mkHelpers pkgs;
        in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs outputs host helpers;
              user = decorateUser user helpers;
            };
            modules = [
              # Link applications defined by Home-Manager to host
              ({config, ...}: {
                xdg = {
                  enable = true;
                  mime.enable = true;
                  systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
                };
              })
              (
                # NonNixos but linux hosts and managed by Home-Manager
                mkIf
                (helpers.isLinux && host.isManagedByHomeManager)
                {
                  targets.genericLinux.enable = true;
                }
              )
              # Enable NixGL
              (
                mkIf host.useNixGL
                {
                  nixGL.packages = inputs.nixgl.packages;
                }
              )
              ./home/${user.username}
              ({helpers, ...}: {
                imports = map (module:
                  ./modules/home-manager/${
                    if helpers.isLinux
                    then "linux"
                    else "darwin"
                  }/${module})
                user.modules;
              })
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
            config.allowUnfree = true;
          };
          helpers = mkHelpers pkgs;
        in
          mkSystem {
            inherit pkgs;
            specialArgs = {
              inherit inputs outputs host helpers;
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
