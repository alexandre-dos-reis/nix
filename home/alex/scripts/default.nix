{
  pkgs,
  ...
}: {
  # need to install cargo and gcc for neovim, move them to neovim folder
  home.packages = with pkgs; [
    (import ./hello.nix pkgs)
    (import ./mkdevdir.nix pkgs)
  ];
}
