{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix helpers
    nix-inspect # inspect flake in a nice interface
    nixos-rebuild
    devenv # Dev

    pavucontrol

    # fonts
    maple-mono.NF-unhinted

    # system utils
    dust
    btop
    yazi
    fastfetch # better neofetch
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
    brotli
    gzip
    nmap
    openssl

    # code
    jujutsu # Alternative to git, use with `jj`
    tokei # Stats about code
    woff2
    (python3.withPackages
      (ps: [ps.fonttools]))

    # git
    tig
    lazygit
    gh # github cli
    # sops
    # ssh-to-age

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
