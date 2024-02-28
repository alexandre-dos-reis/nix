let 
  keyboardLocale = "en_US.UTF-8";
  geoLocale = "fr_FR.UTF-8";
  timeZone = "Europe/Paris";
in {
  time.timeZone = timeZone;

  i18n = {
    defaultLocale = keyboardLocale;
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
