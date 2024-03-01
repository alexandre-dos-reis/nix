{ inputs, globals, ... }: inputs.home-manager.nixosModules.home-manager {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${globals.username} = import ../../../home/${globals.username};
  };
}
