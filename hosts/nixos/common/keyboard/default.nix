{
  imports = [
    ./keyd.nix
    ./xcompose.nix
  ];

  # This enable unicode accents in the terminal
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
  };

  # This is mandatory for unicode characters to be inputed correctly
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };
}
