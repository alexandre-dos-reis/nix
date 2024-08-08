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

  mkOsSystems = os: list:
    builtins.listToAttrs (map ({
        host,
        users,
      }: {
        name = host.hostname;
        value = let
          utils = mkUtils host;
          folder =
            if host.os == linux
            then "nixos"
            else "darwin";
          config = {
            pkgs = mkPkgs {inherit utils host;};
            specialArgs = {inherit inputs outputs host utils users;};
            modules = [
              ./hosts/${folder}/${host.path}
            ];
          };
        in
          if host.os == linux
          then nixpkgs.lib.nixosSystem config
          else nix-darwin.lib.darwin config;
      })
      (builtins.filter ({host, ...}: host.os == os)));
in {
  users = import ./users.nix;
  hosts = import ./hosts.nix inputs;
  mkFlake = list: {
    formatter = forSystems (s: nixpkgs.legacyPackages.${s}.alejandra);
    nixosConfigurations = mkOsSystems linux list;
    darwinConfigurations = mkOsSystems darwin list;
    homeConfigurations = mkHomes list;
  };
}
