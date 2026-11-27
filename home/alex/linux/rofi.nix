{pkgs, ...}: let
  constants = import ../constants.nix;
  colors = constants.colors.palette;

  # Palette entries the theme reads from the environment.
  themeColors = ["base0" "base02" "base03" "cyan500"];
in {
  home.sessionVariables = builtins.listToAttrs (map (name: {
      name = "PALETTE_${pkgs.lib.toUpper name}";
      value = colors."${name}-hex";
    })
    themeColors);

  # App launcher. rofi 2.0 speaks Wayland natively — the old rofi-wayland fork
  # was merged back into pkgs.rofi, so no override is needed here. Not
  # programs.rofi: the config is hand-written in ../symlinks/.config/rofi.
  home.packages = [pkgs.rofi];
}
