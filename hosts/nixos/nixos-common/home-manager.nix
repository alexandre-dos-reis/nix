{
  inputs,
  vars,
  ...
}:
inputs.home-manager.nixosModules.home-manager {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${vars.username} = import ../../../home/${vars.username};
  };
}
