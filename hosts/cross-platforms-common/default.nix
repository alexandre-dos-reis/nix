{
  pkgs,
  host,
  ...
}: let
  timeZone = "Europe/Paris";
in {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = host.system;
  networking.hostName = host.hostname;

  nix.settings.experimental-features = "nix-command flakes";

  users.users.alex.home = /Users/alex;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  environment.systemPackages = with pkgs; [
    # try to install neovim dependencies in the user scope.
    # Shell has to be installed globally...
    fish
    vim
  ];

  time.timeZone = timeZone;

}
