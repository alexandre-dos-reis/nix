{config, ...}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (import ../../constants.nix) flakeDir;
in {
  # Rex's Lua config, kept in the flake so it is version controlled, symlinked
  # out of the store as nvim's is so edits take effect without a rebuild.
  # Rex itself isn't installed through nix, so there is no package to add here.
  home.file.".config/rex".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${flakeDir}/home/alex/dotfiles/rex";
}
