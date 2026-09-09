{
  inputs,
  pkgs-unstable,
  config,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (import ../../constants.nix) flakeDir;
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
    withRuby = false;
    withPython3 = false;
    # Manage init.lua ourselves via the out-of-store symlink below; don't let
    # home-manager write its own ~/.config/nvim/init.lua (it would collide with
    # the whole-directory symlink and fail with "outside $HOME").
    sideloadInitLua = true;
  };

  home.file.".config/nvim".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${flakeDir}/home/alex/dotfiles/nvim";

  # LSPs and executable
  home.packages = with pkgs-unstable; let
    zig = inputs.zig.packages.${pkgs-unstable.stdenv.hostPlatform.system}."0.16.0";
  in [
    # Treesitter
    tree-sitter

    # Code
    opencode

    # Deps for Lazy
    luajitPackages.luarocks

    # bash
    bash-language-server
    beautysh

    # HTML/CSS/JSON/ESLint
    vscode-langservers-extracted

    # Yaml
    yaml-language-server
    cue

    # Javascript / Typescript
    nodejs_24
    # corepack_24
    pnpm
    bun
    deno
    typescript-language-server
    typescript
    vtsls
    prettierd
    eslint_d
    biome
    oxlint
    oxfmt
    astro-language-server
    # dart # for sass

    # Graphql
    graphql-language-service-cli

    # Tailwind
    tailwindcss-language-server

    # Lua
    lua-language-server
    stylua

    # Nix
    nixd
    alejandra # formatter

    # Golang
    air
    go
    gopls
    gofumpt
    goimports-reviser
    golines
    golangci-lint
    gotestsum

    # Rust
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Zig
    zig
    zls

    # Ruby
    ruby
    rubocop
    ruby-lsp
    solargraph

    # Dotnet
    dotnetCorePackages.sdk_9_0
    csharp-ls # community lsp
    # roslyn-ls # official new lsp # not working atm
    omnisharp-roslyn # official old lsp

    # Terraform
    terraform
    terraform-lsp

    # Postgres
    postgres-language-server
    pgformatter

    # Php
    php
    phpactor # lsp
    symfony-cli
    php84Packages.composer # package manager
    php84Packages.php-cs-fixer # formatter

    # C
    gcc # or clang
  ];
}
