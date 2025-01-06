{config, ...}: {
  # See here https://github.com/nix-community/home-manager/issues/1439#issuecomment-1605851533
  # This fix is for loading desktop application files not available with standalone home-manager.

  # Recommended for linux distros other than NixOS
  targets.genericLinux.enable = true;
  xdg = {
    enable = true;
    mime.enable = true;
    systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];
  };
}
