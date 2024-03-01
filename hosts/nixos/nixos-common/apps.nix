{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # try to install neovim dependencies in the user scope.
    # Shell fish has to be installed globally...
    fish
  ];
}
