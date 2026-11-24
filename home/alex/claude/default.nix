{config, ...}: let
  inherit (import ../constants.nix) flakeDir;
in {
  # ~/.claude/settings.json stays hand-managed: Claude Code rewrites it itself
  # (model, theme, enabled plugins), so a read-only store copy would fight it.
  # Only the hooks it points at are tracked here.
  #
  # Linked out of the store, like ./dotfiles, so editing a hook takes effect on
  # the next run with no rebuild. The whole directory is linked, so a new hook
  # script is just a file dropped in — wiring it up is a settings.json edit.
  home.file.".claude/hooks".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/${flakeDir}/home/alex/claude/hooks";
}
