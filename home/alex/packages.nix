{pkgs, ...}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages = with pkgs; [
    # nix helpers
    nix-inspect # inspect flake in a nice interface
    nixos-rebuild
    devenv # Dev

    # fonts
    (maple-mono.NF.overrideAttrs {
      version = "7.2";
    })

    # system utils
    dust
    btop
    yazi
    fastfetch # better neofetch
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
    unzip
    age
    eza
    fd
    fzf
    pandoc
    ripgrep
    tree
    unrar
    go-task
    websocat
    just
    codecrafters-cli

    # code
    jujutsu
    tokei # Stats about code

    # git
    tig
    lazygit
    gh # github cli

    # Keyboard
    qmk
    qmk_hid

    # Postgres
    postgresql # needed for psql
    tbls

    # containers
    lazydocker
    # kubectl
    k9s

    # Gui Apps
    vlc
    libreoffice
    blender
  ];
}
