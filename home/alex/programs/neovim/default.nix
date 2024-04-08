{
  pkgs,
  inputs,
  vars,
  ...
}: let 
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.astro
      p.c
      p.fish
      p.jq
      p.json5
      p.json
      p.jsonc
      p.toml
      p.tsx
      p.typescript
      p.javascript
      p.go
      p.bash
      p.comment
      p.css
      p.dockerfile
      p.gitattributes
      p.gitignore
      p.make
      p.cmake
      p.css
      p.scss
      p.gitignore
      p.graphql
      p.http
      p.php
      p.rust
      p.sql
      p.nix
      p.yaml
  ]));

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = [
      treesitterWithGrammars
    ];
  };


  # https://github.com/nix-community/nixd/blob/main/nixd/docs/user-guide.md#configuration
  home.packages = with pkgs; [
    nixd ## nix lsp
    ripgrep
    fd
  ];

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

  xdg.configFile."nvim/lua/config/treesitter-parsers-runtime.lua".text = ''
    vim.opt.runtimepath:append("${treesitter-parsers}")
  '';

   xdg.dataFile."nvim/nix/nvim-treesitter/" = {
    recursive = true;
    source = treesitterWithGrammars;
  };


}
