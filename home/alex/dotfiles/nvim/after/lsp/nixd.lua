---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  root_markers = { "flake.nix", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake "/home/alex/dev/nix-config").inputs.nixpkgs-unstable { }',
      },
      formatting = {
        command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "/home/alex/dev/nix-config").nixosConfigurations.pangolin.options',
        },
        home_manager = {
          expr = '(builtins.getFlake "/home/alex/dev/nix-config").homeConfigurations."alex@pangolin".options',
        },
      },
    },
  },
}
