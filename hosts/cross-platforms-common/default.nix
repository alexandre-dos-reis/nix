{
  pkgs,
  host,
  ...
}: let
  langLocale = "en_US.UTF-8";
  geoLocale = "fr_FR.UTF-8";
  timeZone = "Europe/Paris";
in {
  nixpkgs.hostPlatform = host.platform;
  networking.hostName = host.hostname;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # try to install neovim dependencies in the user scope.
    # Shell fish has to be installed globally...
    fish
    vim
  ];

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = langLocale;
    extraLocaleSettings = {
      LC_ADDRESS = geoLocale;
      LC_IDENTIFICATION = geoLocale;
      LC_MEASUREMENT = geoLocale;
      LC_MONETARY = geoLocale;
      LC_NAME = geoLocale;
      LC_NUMERIC = geoLocale;
      LC_PAPER = geoLocale;
      LC_TELEPHONE = geoLocale;
      LC_TIME = geoLocale;
    };
  };
}
