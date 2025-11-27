inputs: let
  outputs = inputs.self.outputs;
  users = import ./users.nix;
  nixpkgs = inputs.nixpkgs;
  flattenList = nixpkgs.lib.lists.flatten;
  isDarwinFromSystem = system: inputs.nixpkgs.lib.strings.hasSuffix "darwin" system;
in {
  mkHomes = list:
    builtins.listToAttrs (flattenList (map (host: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = let
          isDarwin = isDarwinFromSystem host.system;
        in
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${host.system};
            extraSpecialArgs = {
              inherit inputs outputs host user;
              useNixGl = !isDarwin;
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
                {pkgs, ...}:
                # Usefull for non-nixos linux system
                  if pkgs.stdenv.isLinux
                  then {
                    targets.genericLinux.enable = true;
                    nixGL.packages = inputs.nixgl.packages;
                  }
                  else {}
              )
              ./home/${user.username}/${
                if isDarwin
                then "darwin"
                else "linux"
              }.nix
            ];
          };
      })
      users))
    list));

  mkSystems = list:
    builtins.listToAttrs (map (host: {
        name = host.hostname;
        value = let
          isDarwin = isDarwinFromSystem host.system;
          systemFunc =
            if isDarwin
            then inputs.nix-darwin.lib.darwin
            else inputs.nixpkgs.lib.nixosSystem;
        in
          systemFunc {
            system = host.system;
            specialArgs = {
              inherit inputs host users outputs;
            };
            modules = [
              # Allow unfree packages.
              {nixpkgs.config.allowUnfree = true;}

              # Call host config
              ./hosts/${
                if isDarwin
                then "darwin"
                else "nixos"
              }/${host.hostname}

              # Call Home-manager module
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = false;
                  useUserPackages = true;
                  users = builtins.listToAttrs (map (user: {
                      name = user.username;
                      value =
                        ./home/${user.username}/${
                          if isDarwin
                          then "darwin"
                          else "linux"
                        }.nix;
                    })
                    users);
                  extraSpecialArgs = {
                    inherit inputs outputs host;
                    useNixGl = false;
                    users = builtins.listToAttrs (map (user: {
                        name = user.username;
                        value = user;
                      })
                      users);
                  };
                };
              }
            ];
          };
      })
      list);
}
