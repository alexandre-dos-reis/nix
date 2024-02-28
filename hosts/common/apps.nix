{pkgs, ...}:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
