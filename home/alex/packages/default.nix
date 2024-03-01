{pkgs, ...}: {
  imports = [
    ./kavval.nix
  ];

  home.packages = with pkgs; [
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
  ];
}
