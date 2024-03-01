{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # try to install neovim dependencies in the user scope.
    neovim
    libgcc
    zig
    cargo
    gnumake
    sqlite
    rustc
    nodejs
    wget
    git
    age
    ansible
    bun
    chezmoi
    docker
    eza
    fd
    fish
    fluxcd
    fzf
    gh
    btop
    lazygit
    pandoc
    ripgrep
    sops
    gnupg
    timoni
    tmux
    firefox
  ];
}
