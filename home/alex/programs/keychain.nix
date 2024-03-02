{globals, ...}: {
  programs.keychain = {
    # enable = globals.utils.isLinux;
    enable = false; # Need to try fish plugin first on linux...
    enableFishIntegration = true;
    keys = [
      /home/${globals.username}/.ssh/id_ed25519
      /home/${globals.username}/.ssh/id_ed25519_old
    ];
  };
}
