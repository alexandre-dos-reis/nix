{pkgs, ...}: {
  home.packages = with pkgs;[
    # Javascript/Typescript
    typescript-language-server # Find a way to install vtsls
    typescript
    prettierd
    eslint_d

    # Lua
    lua-language-server
    stylua
  ];
}
