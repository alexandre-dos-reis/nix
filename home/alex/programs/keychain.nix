{globals, ...}: {
  programs.keychain = {
    enable = globals.utils.isLinux;
    enableFishIntegration = true;
    keys = [
      /home/${globals.username}/.ssh/id_ed25519
      /home/${globals.username}/.ssh/id_ed25519_old
    ];
  };
}
