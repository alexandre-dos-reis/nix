{
  pkgs,
  utils,
  ...
}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages = with pkgs; [
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
    # bun
    go
    # rust
    rustc
    cargo

    # Keyboard
    qmk
  ];
}
