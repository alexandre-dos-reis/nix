{pkgs, ...}: let
 inherit (pkgs.stdenv) isDarwin;
in{
  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = [
        "Meslo"
        "JetBrainsMono"
      ];
    })
  ];

  # keyboard layout
  # https://mipmip.github.io/home-manager-option-search/?query=keyboard
  home.keyboard = {
    # TODO:: try these layout on Darwin:
    # "Unicode Hex Input";
    # "U.S.";
    # "French - numerical";
    # "French";
    layout = if isDarwin then "Unicode Hex Input" else "us"; 
  };
}
