{pkgs, ...}:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    age
    ansible
    bun
    chezmoi
    dagger
    docker
    exa
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
  ];
}
