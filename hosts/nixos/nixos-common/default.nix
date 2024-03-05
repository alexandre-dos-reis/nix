let 
  langLocale = "en_US.UTF-8";
  geoLocale = "fr_FR.UTF-8";
in {
  imports = [
    ../../cross-platforms-common
    ./home-manager.nix
  ];

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
