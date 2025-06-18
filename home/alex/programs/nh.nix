{user, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10";
    flake = "${user.homeDir}/dev/nix-config";
  };
}
