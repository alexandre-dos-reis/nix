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

  # LSPs
  home.packages = with pkgs; [
    # Javascript / Typescript
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
  ];
}
