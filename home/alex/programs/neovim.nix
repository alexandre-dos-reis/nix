{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
  };

  # LSPs and executable
  home.packages = with pkgs; let
    zig = inputs.zig.packages.${pkgs.stdenv.hostPlatform.system}."0.15.2";
  in [
    # Code
    opencode

    # Deps for Lazy
    luajitPackages.luarocks

    # bash
    nodePackages.bash-language-server
    beautysh

    # HTML/CSS/JSON/ESLint
    vscode-langservers-extracted

    # Yaml
    yaml-language-server

    # Javascript / Typescript
    nodejs_24
    corepack_24
    nodePackages.nodemon
    nodePackages.prettier
    nodePackages.vercel
    nodePackages."@astrojs/language-server"
    bun
    deno
    typescript-language-server
    typescript-go
    vtsls
    typescript
    prettierd
    eslint_d
    biome
    oxlint
    # dart # for sass

    # Graphql
    graphql-language-service-cli

    # Tailwind
    tailwindcss-language-server
    # nodePackages.neovim # Needed for tailwind-tools

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
    # zls

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
