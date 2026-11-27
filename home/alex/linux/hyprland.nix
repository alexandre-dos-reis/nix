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

  colors = constants.colors.palette;
in {
  home.sessionVariables = paletteVars;

  # Wayle replaces waybar (bar), swaync (notification daemon) and the volume /
  # brightness OSD in one shell. It runs as a systemd user service hanging off
  # wayland.systemd.target (graphical-session.target), which hyprland.lua's start
  # hook brings up *after* dbus-update-activation-environment, so unlike
  # hyprpaper it gets WAYLAND_DISPLAY and needs no exec_cmd of its own.
  #
  # No `settings`: config.toml is hand-written in ../symlinks/.config/wayle.
  # After changing it or the palette, if the bar doesn't pick it up:
  # `systemctl --user restart wayle`.
  services.wayle = {
    enable = true;
    # Soft deps pulled in from the config: nothing extra while theme-provider
    # is "wayle" and the wallpaper engine is off (hyprpaper still owns that).
    autoInstallDependencies = true;
  };

  # Imported by wayle's config.toml. It sits outside ~/.config/wayle because
  # that whole directory is a link into the repo.
  xdg.configFile."wayle-palette.toml".source = (pkgs.formats.toml {}).generate "wayle-palette.toml" {
    styling.palette = {
      bg = constants.colors.background;
      surface = colors.base03-hex;
      elevated = colors.base02-hex;
      fg = colors.base0-hex;
      fg-muted = colors.base01-hex;
      primary = colors.cyan500-hex;
      red = colors.red500-hex;
      yellow = colors.yellow500-hex;
      green = colors.green500-hex;
      blue = colors.blue500-hex;
    };
  };

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
    # App launcher. rofi 2.0 speaks Wayland natively — the old rofi-wayland fork
    # was merged back into pkgs.rofi, so no override is needed here. Not
    # programs.rofi: the config is hand-written in ../symlinks/.config/rofi.
    rofi
    nerd-fonts.caskaydia-mono # wayle's font, set in its config.toml
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
}
