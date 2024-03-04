{vars, ...}: {
  programs.keychain = {
    # enable = globals.utils.isLinux;
    enable = false; # Need to try fish plugin first on linux...
    enableFishIntegration = true;
    keys = [
      /home/${vars.username}/.ssh/id_ed25519
      /home/${vars.username}/.ssh/id_ed25519_old
    ];
  };
}
