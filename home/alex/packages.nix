{
  pkgs,
  utils,
  ...
}: {
  imports = [
    ./kavval.nix
  ];

  home.packages = with pkgs;
    [
      dust
      btop
      neofetch
      libgcc
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
      firefox
      tree
      unrar
    ]
    ++ (
      if utils.isDarwin
      then
        with pkgs; [
          # Packages for darwin
          gnused # sed on darwin isn't the same as gnused.
        ]
      else [
      ]
    );
}
