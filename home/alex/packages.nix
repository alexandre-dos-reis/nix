{
  pkgs,
  utils,
  inputs,
  ...
}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages = [
    # overlays from inputs
    inputs.zig.packages.${pkgs.system}.master
  ] ++ (with pkgs; [
    # nix helpers
    nh # cli wrapper
    devenv # Dev

    # system utils
    dust
    btop
    yazi
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
    ssh-to-age
    # firefox: Not available on silicon platform
    tree
    unrar
    go-task
    # coreutils
    # openssl
    websocat

    # langs
    bun
    ## golang
    go
    air 
    # rust
    rustc
    cargo
    dotnetCorePackages.sdk_9_0
    ## utils
    tokei # Stats about code

    # Keyboard
    qmk

    # Postgres
    postgresql # needed for psql
    tbls

    # containers
    lazydocker

    # Gui Apps
    whatsapp-for-linux
    simplescreenrecorder
    vlc
  ]);
}
