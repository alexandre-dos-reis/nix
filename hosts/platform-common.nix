{
  pkgs,
  host,
  vars,
  utils,
  ...
}: let
  inherit (vars) username;
  inherit (pkgs.stdenv) isDarwin;
in {
  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = host.system;
  networking.hostName = host.hostname;

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  users.users.${username} = {
    home = utils.getHomeDir {inherit username isDarwin;};
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  environment.systemPackages = with pkgs; [
    vim
    zsh
    fish
  ];
}
