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
  ];
}
