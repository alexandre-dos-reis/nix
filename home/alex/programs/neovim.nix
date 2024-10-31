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
  };

  # xdg.configFile.nvim = {
  #   source = ./config;
  #   recursive = true;
  # };

  # https://github.com/nix-community/nixd/blob/main/nixd/docs/user-guide.md#configuration
  home.packages = with pkgs;
  with pkgs.tree-sitter-grammars; [
    # LSPs
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

    # TREESITTER PARSERS
    tree-sitter-typescript

    # TODO: Implement theses parsers
    # "html",
    # "lua",
    # "tsx",
    # "javascript",
    # "go",
    # "astro",
    # "cmake",
    # "css",
    # "scss",
    # "fish",
    # "gitignore",
    # "markdown",
    # "graphql",
    # "http",
    # "php",
    # "rust",
    # "sql",
    # "nix",
    # "just",
    # "terraform",
    # "zig",
  ];
}
