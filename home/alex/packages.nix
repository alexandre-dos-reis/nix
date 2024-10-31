{
  pkgs,
  utils,
  inputs,
  ...
}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages =
    [
      # overlays from inputs
      inputs.zig.packages.${pkgs.system}."0.13.0"
    ]
    ++ (with pkgs; [
      # nix helpers
      nixos-rebuild
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

      # code
      jujutsu
      ## golang
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
      kubectl
      k9s

      # Gui Apps
      whatsapp-for-linux
      simplescreenrecorder
      vlc
    ]);
}
