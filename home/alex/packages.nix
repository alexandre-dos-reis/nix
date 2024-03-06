{
  pkgs,
  utils,
  ...
}: {
  home.packages = with pkgs;
    [
      dust
      btop
      neofetch
      # libgcc Apparently, not a package, need to find an alternative.
      gnumake
      gnupg
      jq
      wget
      sqlite
      zip
      age
      ansible
      eza
      fd
      fzf
      lazygit
      pandoc
      ripgrep
      sops
      # firefox: Not available on silicon platform
      tree
      unrar
    ];
}
