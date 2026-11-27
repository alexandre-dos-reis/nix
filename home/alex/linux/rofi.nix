{
  lib,
  pkgs,
  ...
}: let
  constants = import ../constants.nix;

  # Every hex color of the palette, e.g. base0-hex -> PALETTE_BASE0.
  paletteVars = lib.mapAttrs' (name: value:
    lib.nameValuePair "PALETTE_${lib.toUpper (lib.removeSuffix "-hex" name)}" value)
  (lib.filterAttrs (name: _: lib.hasSuffix "-hex" name) constants.colors.palette);
in {
  home.sessionVariables = paletteVars;

  # App launcher. rofi 2.0 speaks Wayland natively — the old rofi-wayland fork
  # was merged back into pkgs.rofi, so no override is needed here. Not
  # programs.rofi: the config is hand-written in ../symlinks/.config/rofi.
  home.packages = [pkgs.rofi];
}
