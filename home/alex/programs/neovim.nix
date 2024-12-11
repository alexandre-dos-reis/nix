{
  pkgs,
  inputs,
  user,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = inputs.nvim-nightly.packages.${pkgs.system}.default;
  };

  # LSPs and executable
  home.packages = with pkgs; let
    zig = inputs.zig.packages.${pkgs.system}."0.13.0";
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
    nodejs_20
    corepack_20
    nodePackages.nodemon
    nodePackages.prettier
    nodePackages.vercel
    bun
    deno
    typescript-language-server
    typescript
    prettierd
    eslint_d

    # Graphql
    nodePackages.graphql-language-service-cli

    # Tailwind
    tailwindcss-language-server
    #
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
  ];
}
