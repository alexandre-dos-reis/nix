{
  inputs,
  outputs,
  vars,
  utils,
  host,
  ...
}:
inputs.home-manager.nixosModules.home-manager {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${vars.username} = import ../../../home/${vars.username};
    extraSpecialArgs = {inherit inputs outputs vars utils host;};
  };
}
