{
  inputs,
  pkgs-unstable,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
    initLua = ''
      local user_config = vim.fn.stdpath("config") .. "/lua/init.lua"
      if vim.uv.fs_stat(user_config) then
        dofile(user_config)
      end
    '';
    withRuby = false;
    withPython3 = false;
  };

  # LSPs and executable
  home.packages = with pkgs-unstable; let
    zig = inputs.zig.packages.${pkgs-unstable.stdenv.hostPlatform.system}."0.15.2";
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
    corepack_24
    bun
    deno
    typescript-language-server
    typescript-go
    vtsls
    prettierd
    eslint_d
    biome
    oxlint
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
