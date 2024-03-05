{
  pkgs,
  host,
  ...
}: let
  timeZone = "Europe/Paris";
in {
  nixpkgs.hostPlatform = host.platform;
  networking.hostName = host.hostname;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # try to install neovim dependencies in the user scope.
    # Shell has to be installed globally...
    fish
    vim
  ];

  time.timeZone = timeZone;

}
