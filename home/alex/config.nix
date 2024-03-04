{pkgs, ...}: {
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
  home.keyboard = {
    # https://mipmip.github.io/home-manager-option-search/?query=keyboard
  };
}
