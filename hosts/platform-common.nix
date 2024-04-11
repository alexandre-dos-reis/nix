{
  pkgs,
  host,
  vars,
  ...
}: let
  inherit (vars) username homeDirectory;
in {
  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = host.system;
  networking.hostName = host.hostname;

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  users.users.${username} = {
    home = homeDirectory;
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  environment.systemPackages = with pkgs; [
    # try to install neovim dependencies in the user scope.
    # Shell has to be installed globally...
    vim
    zsh
  ];
}
