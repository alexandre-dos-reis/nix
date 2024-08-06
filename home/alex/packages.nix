{
  pkgs,
  utils,
  ...
}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages = with pkgs; [
    # nix helpers
    nh # cli wrapper
    devenv # Dev

    # system utils
    dust
    btop
    neofetch
    clang
    gnumake
    cmake
    gnumake
    gnupg
    bat
    jq
    just
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
    # input-remapper
    tree
    unrar

    # languages
    bun
    go
    # rust
    rustc
    cargo
    tokei

    # Keyboard
    qmk

    # Postgres
    postgresql # needed for psql
    tbls

    # containers
    lazydocker

  ];
}
