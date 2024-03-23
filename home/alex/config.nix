{pkgs, ...}: let
  inherit (pkgs.stdenv) isDarwin;
in {
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
  # https://dev.to/tallesl/change-caps-lock-to-ctrl-3c4
  # https://www.reddit.com/r/NixOS/comments/trkfyz/overriding_configurationnix_with_homemanager/
  # TODO:: try these layout on Darwin:
  # "Unicode Hex Input";
  # "U.S.";
  # "French - numerical";
  # "French";
   home.keyboard = if isDarwin then {
     layout = "Unicode Hex Input";
   } else {
     layout = "us";
     options = [ "ctrl:nocaps" ];
   };
}
