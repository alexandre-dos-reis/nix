{
  config,
  pkgs,
  ...
}: let
  constants = import ../constants.nix;
  colors = constants.colors.palette;
in {
  # App launcher. rofi 2.0 speaks Wayland natively — the old rofi-wayland fork
  # was merged back into pkgs.rofi, so no override is needed here.
  programs.rofi = {
    enable = true;
    # extraConfig is merged last into rofi's `configuration` block, so the
    # module's typed font/terminal/modes options are redundant with it.
    extraConfig = {
      font = "${constants.font} 12";
      terminal = "${pkgs.ghostty}/bin/ghostty";
      modes = ["drun"];
      show-icons = true;
      drun-display-format = "{name}";
      case-sensitive = false;
      hide-scrollbar = true;
    };
    # Carried over from the wofi.css this replaced: 700x400, 7px radius, two
    # columns. Anything that isn't a plain string, int or bool has to go
    # through mkLiteral or it lands in the rasi quoted.
    # https://mynixos.com/home-manager/option/programs.rofi.theme
    # mkLiteral keeps values bare in the rasi; a plain string would come out
    # quoted, which rofi rejects for colors and sizes.
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral colors.base0-hex;
      };

      window = {
        width = mkLiteral "700px";
        height = mkLiteral "400px";
        border = mkLiteral "1px";
        border-color = mkLiteral colors.base0-hex;
        border-radius = mkLiteral "7px";
        background-color = mkLiteral colors.base03-hex;
        padding = mkLiteral "10px";
      };

      mainbox = {
        spacing = mkLiteral "5px";
        children = map mkLiteral ["inputbar" "listview"];
      };

      inputbar = {
        padding = mkLiteral "4px 13px";
        children = map mkLiteral ["entry"];
      };

      entry.vertical-align = mkLiteral "0.5";

      listview = {
        columns = 2;
        scrollbar = false;
        spacing = mkLiteral "4px";
      };

      element = {
        padding = mkLiteral "4px";
        spacing = mkLiteral "10px";
        border-radius = mkLiteral "7px";
        children = map mkLiteral ["element-icon" "element-text"];
      };

      element-icon = {
        size = mkLiteral "24px";
        vertical-align = mkLiteral "0.5";
      };

      element-text = {
        vertical-align = mkLiteral "0.5";
        text-color = mkLiteral "inherit";
      };

      # Selection highlight; wofi's was transparent, i.e. invisible.
      "element selected" = {
        background-color = mkLiteral colors.base02-hex;
        text-color = mkLiteral colors.cyan500-hex;
      };
    };
  };
}
