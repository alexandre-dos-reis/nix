{
  pkgs,
  utils,
  inputs,
  ...
}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages = with pkgs; [
    # nix helpers
    nix-inspect # inspect flake in a nice interface
    nixos-rebuild
    devenv # Dev

    # system utils
    dust
    btop
    yazi
    neofetch
    clang
    gnumake
    cmake
    gnupg
    bat
    jq
    yq
    wget
    sqlite
    zip
    age
    ansible
    eza
    fd
    fzf
    lazygit
    gh # github cli
    pandoc
    ripgrep
    tree
    unrar
    go-task
    websocat
    just

    # code
    jujutsu
    tokei # Stats about code

    # Keyboard
    qmk

    # Postgres
    postgresql # needed for psql
    tbls

    # containers
    lazydocker
    kubectl
    k9s

    # Gui Apps
    whatsapp-for-linux
    simplescreenrecorder
    vlc
  ];
}
