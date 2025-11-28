let
  constants = import ../constants.nix;
in {
  # See user.nix files
  home.file.".npmrc".text = ''
    prefix=${constants.npm.packages.path}
  '';
}
