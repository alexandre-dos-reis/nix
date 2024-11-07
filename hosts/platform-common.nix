{
  pkgs,
  host,
  users,
  utils,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  inherit (users) alex;
in {
  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = host.system;
  networking.hostName = host.hostname;

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  # TODO: iterate users
  # users.users.${alex.username} = {
  #   home = user.
  #   shell = pkgs.fish;
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  environment.systemPackages = with pkgs; [
    vim
    zsh
    fish
  ];
}
