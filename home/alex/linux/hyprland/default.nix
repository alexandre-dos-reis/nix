{pkgs, ...}: let
  constants = import ../../constants.nix;
  colors = constants.colors.palette;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    # package and portalPackage are backed by nixos
    package = null;
    portalPackage = null;

    # Kept for hyprland-session.target and the portal wiring, not for the
    # config: ~/.config/hypr is linked whole out of the repo by ../../symlinks,
    # and home-manager refuses to install through that link. extraConfig only
    # silences the module's "no configuration" warning — it lands in the file
    # disabled just below, which is never written.
    extraConfig = "-- Unused. The real config is hyprland.lua, hand-written in ../../symlinks/.config/hypr.";
  };

  # The one thing the module must not do. Everything else it sets up — the
  # session target that starts graphical-session.target, xdg.portal — stays.
  # hyprland.lua itself carries the dbus/systemctl start hook the generated
  # file used to.
  xdg.configFile."hypr/hyprland.lua".enable = false;
  xdg.configFile."hypr/.luarc.json".enable = false;

  home.pointerCursor = {
    name = constants.cursor.theme;
    size = constants.cursor.size;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.${constants.cursor.pkgs};
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = constants.cursor.theme;
      size = constants.cursor.size;
      package = pkgs.${constants.cursor.pkgs};
    };
  };

  home.packages = with pkgs; [
    clipse
    wl-clipboard
    hyprshot
    nautilus
    file-roller # Archive manager, MIME handler so Nautilus can open zip/tar/etc.
    hyprpaper # launched from hyprland.lua's start hook, not services.hyprpaper:
    # its unit starts at graphical-session.target, racing the
    # dbus-update-activation-environment that gives it WAYLAND_DISPLAY
    brightnessctl # Control brightness display
    playerctl # Control audio
  ];

  # App launcher. rofi 2.0 speaks Wayland natively — the old rofi-wayland fork
  # was merged back into pkgs.rofi, so no override is needed here.
  xdg.dataFile."rofi/themes/solarized.rasi".source = pkgs.replaceVars ./rofi.rasi {
    font = constants.font;
    bgColor = colors.base03-hex; # Background
    fgColor = colors.base0-hex; # Foreground
    mgColor = colors.base02-hex; # Selected row background
    selectedColor = colors.cyan500-hex; # Selected row text, matching wayle's accent
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    font = "${constants.font} 12";
    modes = ["drun"];
    # Referenced by name, not by path: home-manager's `theme` option treats any
    # attrset as inline rasi, and a replaceVars derivation *is* an attrset, so
    # handing it the derivation aborts the eval. Installing the file ourselves
    # and naming it sidesteps that — rofi resolves bare names against
    # $XDG_DATA_HOME/rofi/themes.
    theme = "solarized";
    extraConfig = {
      show-icons = true;
      drun-display-format = "{name}";
      case-sensitive = false;
      hide-scrollbar = true;
    };
  };
}
