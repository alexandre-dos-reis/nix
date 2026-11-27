{
  config,
  lib,
  ...
}: let
  inherit (import ../constants.nix) flakeDir;

  root = "${config.home.homeDirectory}/${flakeDir}/home/alex/symlinks";

  # This tree mirrors $HOME, so dropping a config in is all it takes — no list
  # to keep in sync here. A directory holding regular files is linked whole, so
  # adding a file to an already-linked config needs no rebuild either; one
  # holding nothing but directories is recursed into, which is what lets the
  # mirror go as deep as a given config needs (claude/hooks, not claude).
  collect = relative: dir: let
    entries = builtins.readDir dir;
    subdirs = lib.filterAttrs (_: type: type == "directory") entries;
    hasFiles = lib.any (type: type != "directory") (builtins.attrValues entries);
    descend = name: _:
      collect
      (
        if relative == ""
        then name
        else "${relative}/${name}"
      )
      (dir + "/${name}");
  in
    # The root itself holds this file, so it never counts as a link target.
    if relative != "" && hasFiles
    then [relative]
    else lib.concatLists (lib.mapAttrsToList descend subdirs);

  # Linked out of the store so edits take effect without a rebuild. The tools
  # themselves may or may not be installed through nix; this only places their
  # config.
  linkOutOfStore = paths:
    lib.listToAttrs (map (path: {
        name = path;
        value.source = config.lib.file.mkOutOfStoreSymlink "${root}/${path}";
      })
      paths);
in {
  home.file = linkOutOfStore (collect "" ./.);
}
