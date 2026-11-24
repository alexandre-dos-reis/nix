{
  config,
  lib,
  ...
}: let
  inherit (import ./constants.nix) flakeDir;

  # Every directory in ./dotfiles is a config to link, so dropping one in is
  # all it takes — no list to keep in sync here.
  names =
    builtins.attrNames
    (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./dotfiles));

  # Symlink ~/.config/<name> to dotfiles/<name>, out of the store so edits take
  # effect without a rebuild. The tools themselves may or may not be installed
  # through nix; this only places their config.
  linkConfigs = names:
    lib.listToAttrs (map (name: {
        name = ".config/${name}";
        value.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${flakeDir}/home/alex/dotfiles/${name}";
      })
      names);
in {
  home.file = linkConfigs names;
}
