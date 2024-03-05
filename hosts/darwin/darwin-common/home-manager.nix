{
  inputs,
  outputs,
  vars,
  utils,
  host,
  ...
}: inputs.home-manager.darwinModules.home-manager {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.${vars.username}.imports = [../../../home/${vars.username}];
    home-manager.extraSpecialArgs = { inherit inputs outputs vars utils host;};
}
