# Wayle replaces waybar (bar), swaync (notification daemon) and the volume /
# brightness OSD in one shell. It runs as a systemd user service hanging off
# wayland.systemd.target (graphical-session.target), which hyprland.lua's start
# hook brings up *after* dbus-update-activation-environment, so unlike hyprpaper
# it gets WAYLAND_DISPLAY and needs no exec_cmd of its own.
#
# config.toml is generated from `settings` below, so it lands in the store
# read-only: the settings GUI (`wayle panel settings`) writes its edits to
# ~/.config/wayle/runtime.toml instead. To fold a GUI session back in here:
#   cd ~/.config/wayle && nix-instantiate --eval --expr \
#     '(builtins.fromTOML (builtins.readFile ./config.toml)) // (builtins.fromTOML (builtins.readFile ./runtime.toml))' | nixfmt
# then delete runtime.toml so it stops shadowing this file.
#
# `nh os switch` rewrites config.toml but leaves the running unit on the old
# one — follow it with `systemctl --user restart wayle`.
{pkgs, ...}: let
  constants = import ../../constants.nix;
  colors = constants.colors.palette;

  # The font waybar used to run at 16px/400. It left with waybar.nix, so the
  # bar has to bring it back itself or fontconfig silently falls back.
  barFont = "CaskaydiaMono Nerd Font";

  # Icon chips sit on the wallpaper-matching background rather than a lighter
  # elevated token, so they read as cut out of the bar instead of raised.
  iconBg = constants.colors.background;
in {
  home.packages = [pkgs.nerd-fonts.caskaydia-mono];

  services.wayle = {
    enable = true;
    # Soft deps pulled in from the config: nothing extra while theme-provider
    # is "wayle" and the wallpaper engine is off (hyprpaper still owns that).
    autoInstallDependencies = true;

    settings = {
      general = {
        font-mono = barFont;
        font-sans = barFont;
      };

      bar = {
        bg = "bg-base";
        # Wayle has no px font size — label text is this multiplier off the
        # theme's base size. 0.8 lands near waybar's old 16px, and "normal"
        # matches the 400 weight it used instead of wayle's semibold default.
        button-icon-size = 0.8;
        button-label-padding = 0.6;
        button-label-size = 0.8;
        button-label-weight = "normal";
        button-gap = 1.65;
        button-variant = "basic";
        padding = 0.5;
        # "*" covers both eDP-1 and DP-3; a per-monitor layout would be an
        # extra entry with `extends = "*"`.
        layout = [
          {
            monitor = "*";
            show = true;
            left = ["dashboard" "ram" "cpu" "storage" "battery"];
            center = [];
            right = ["bluetooth" "volume" "network" "weather" "notifications" "systray" "clock"];
          }
        ];
      };

      # Every module below paints its icon in the `accent` token on an `iconBg`
      # chip; the bar itself sits on `bg-base`, which styling.palette resolves
      # to that same color.
      modules = {
        battery = {
          border-color = "accent";
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-color = "accent";
        };
        bluetooth = {
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-color = "accent";
        };
        clock = {
          format = "%H:%M";
          dropdown-show-seconds = false;
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
        };
        cpu = {
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-color = "accent";
        };
        dashboard = {
          border-color = "bg-elevated";
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
        };
        network = {
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
        };
        notifications = {
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-show = false;
          popup-position = "top-center";
        };
        ram = {
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-color = "accent";
        };
        storage = {
          mount-point = "/";
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-color = "accent";
        };
        volume = {
          button-bg-color = iconBg;
          icon-bg-color = iconBg;
          icon-color = "accent";
          label-color = "accent";
        };
        weather = {
          location = "Blèves";
          units = "metric";
          icon-bg-color = iconBg;
          button-bg-color = iconBg;
          icon-color = "accent";
        };
      };

      # Volume / brightness / caps-lock overlay, so the keybinds in
      # hyprland.lua get feedback without a separate swayosd.
      osd = {
        enabled = true;
        position = "bottom";
      };

      styling = {
        # Dropdowns and popovers, which don't follow bar.scale.
        scale = 0.9;
        theme-provider = "wayle";
        palette = {
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
    };
  };
}
