{user, ...}: {
  # See user.nix files
  home.file.".npmrc".text = ''
    prefix=${user.npm.packages.path}
  '';
}
