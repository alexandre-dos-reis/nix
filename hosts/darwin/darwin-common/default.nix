{
  rev,
  utils,
}: {
  imports = [
    ../../cross-platforms-common
    ./home-manager.nix
  ];
  # https://github.com/LnL7/nix-darwin/blob/master/modules/examples/flake/flake.nix
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = utils.rev or utils.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
