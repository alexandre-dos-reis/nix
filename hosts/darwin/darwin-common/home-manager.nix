{
  inputs,
  vars,
  ...
}:
inputs.home-manager.darwinModules.home-manager {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${vars.username} = import ../../../home/${vars.username};
  };
}
