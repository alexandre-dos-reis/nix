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

  # App launcher
  programs.wofi = {
    enable = true;
    style = pkgs.replaceVars ./wofi.css {
      bgColor = colors.base03-hex; # Background color
      fgColor = colors.base0-hex; # Foreground color
      mgColor = colors.base00-hex; # Middleground color
    };
    settings = {
      width = 700;
      height = 400;
      location = "center";
      columns = 2;
      show = "drun";
      prompt = "";
      filter_rate = 100;
      allow_markup = true;
      dmenu-parse_actions = true;
      no_actions = false;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 24;
      gtk_dark = true;
      layer = "top";
      term = "ghostty";
      hide_scroll = true;
      normal_window = true;
      line_wrap = "word_char";
      dymanic_lines = true;
    };
  };
}
