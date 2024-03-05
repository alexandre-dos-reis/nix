{
  inputs,
  vars,
  outputs,
  ...
}: let
  nixpkgs = inputs.nixpkgs;
  pkgs = nixpkgs.legacyPackages;
  utils = {
    isNixOs = builtins.pathExists /etc/nixos;
    ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
  };
  systems = [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  forSystems = nixpkgs.lib.genAttrs systems;
in {
  mkFormatter = forSystems (s: pkgs.${s}.alejandra);

  mkNixos = hosts:
    builtins.listToAttrs
    (builtins.map
      (host: {
        name = host.hostname;
        value = nixpkgs.lib.nixosSystem {
          system = host.system;
          specialArgs = {inherit inputs outputs vars utils host;};
          modules = [./hosts/nixos/${host.folder}];
        };
      })
      hosts);

  mkDarwin = hosts:
    builtins.listToAttrs
    (builtins.map
      (host: {
        name = host.hostname;
        value = inputs.nix-darwin.lib.darwinSystem {
          system = host.system;
          specialArgs = {inherit inputs outputs vars utils host;};
          modules = [./hosts/darwin/siliconWork
		inputs.home-manager.darwinModules.home-manager {
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.users.alex.imports = [./home/alex];
		    home-manager.extraSpecialArgs = { inherit inputs outputs vars utils host;};
		}
		];
        };
      })
      hosts);

  mkHome = hosts:
    builtins.listToAttrs
    (builtins.map
      ({
        username,
        host,
      }: {
        name = "${username}@${host.hostname}";
        value = inputs.home-manager.lib.homeManagerConfigurations {
          pkgs = pkgs.${host.system};
          extraSpecialArgs = {inherit inputs outputs vars utils host;};
          modules = [./home/${username}];
        };
      })
      hosts);
}
