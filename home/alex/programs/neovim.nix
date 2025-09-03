{
  pkgs,
  inputs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # package = inputs.nvim-nightly.packages.${pkgs.system}.default;
  };

  # LSPs and executable
  home.packages = with pkgs; let
    zig = inputs.zig.packages.${pkgs.system}.master;
  in [
    # Deps for Lazy
    luajitPackages.luarocks

    # bash
    nodePackages.bash-language-server
    beautysh

    # Json
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
    vtsls
    typescript
    prettierd
    eslint_d
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

    # Rust
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Zig
    zig
    zls

    # Dotnet
    dotnetCorePackages.sdk_8_0_3xx
    # csharp-ls
    omnisharp-roslyn

    # Terraform
    terraform
    terraform-lsp

    # Postgres
    postgres-lsp
    pgformatter

    # Php
    phpactor
  ];
}
