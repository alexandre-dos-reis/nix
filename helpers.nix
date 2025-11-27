inputs: let
  outputs = inputs.self.outputs;
  users = import ./users.nix;
  nixpkgs = inputs.nixpkgs;
  flattenList = nixpkgs.lib.lists.flatten;
in {
  mkHomes = list:
    builtins.listToAttrs (flattenList (map (host: (map (user: {
        name = "${user.username}@${host.hostname}";
        value = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${host.system};
          extraSpecialArgs = {
            inherit inputs outputs host user;
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
                if pkgs.stdenv.isLinux
                then {
                  targets.genericLinux.enable = true;
                }
                else {}
            )
            # Enable NixGL
            {
              nixGL.packages = inputs.nixgl.packages;
            }
            ./home/${user.username}
          ];
        };
      })
      users))
    list));

  mkSystems = list:
    builtins.listToAttrs (map (host: {
        name = host.hostname;
        value = let
          isDarwin = inputs.nixpkgs.lib.strings.hasSuffix "darwin" host.system;
          systemFunc =
            if isDarwin
            then inputs.nix-darwin.lib.darwin
            else inputs.nixpkgs.lib.nixosSystem;
        in
          systemFunc {
            specialArgs = {
              inherit inputs host users outputs;
            };
            modules = [
              # Allow unfree packages.
              {nixpkgs.config.allowUnfree = true;}
              # Call Home-manager module
              (inputs.home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users = builtins.listToAttrs (map (user: {
                    name = user.username;
                    value = "./home/${user.username}";
                  })
                  users);
                home-manager.extraSpecialArgs = {
                  inherit inputs outputs host;
                  users = builtins.listToAttrs (map (user: {
                      name = user.username;
                      value = user;
                    })
                    users);
                };
              })
            ];
          };
      })
      list);
}
