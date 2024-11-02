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
    package = inputs.nvim-nightly.packages.${pkgs.system}.default;
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
        with p; [
          html
          lua
          tsx
          typescript
          javascript
          go
          astro
          cmake
          css
          scss
          fish
          gitignore
          markdown
          graphql
          http
          php
          rust
          sql
          nix
          just
          terraform
          zig
        ]))
    ];
  };

  # LSPs and executable
  home.packages = with pkgs; [
    # Deps for Lazy
    luajitPackages.luarocks

    # Javascript / Typescript
    nodejs_18
    corepack_18
    # These will be installed globally
    nodePackages.nodemon
    nodePackages.prettier
    nodePackages.vercel
    bun
    typescript-language-server # Find a way to install vtsls
    typescript
    prettierd
    eslint_d

    # Tailwind
    tailwindcss-language-server
    nodePackages.neovim # Needed for tailwind-tools

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
  ];
}
