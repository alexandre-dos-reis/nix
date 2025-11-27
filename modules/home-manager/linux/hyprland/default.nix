{
  pkgs,
  user,
  ...
}: let
  attrsToList = pkgs.lib.attrsets.attrsToList;
  join = pkgs.lib.strings.concatStringsSep;

  colors = user.colors.palette;
  borderActiveColor = colors.base02-rgbhex;
  borderInativeColor = "rgba(07354100)";

  monitors = {
    laptop = {
      name = "eDP-1";
      scale = "2";
      position = "auto";
    };
    lg = {
      name = "DP-3"; # Plugged on the top left usbc input.
      scale = "1.666667";
      position = "auto-left";
    };
  };
in {
  # TODO: https://www.youtube.com/watch?v=zt3hgSBs11g
  # Example of script using pid
  # https://www.emadelsaid.com/Open%20application%20in%20workspace%20Hyprland/
  # https://blogs.kde.org/2024/10/09/cursor-size-problems-in-wayland-explained/

  imports = [./waybar.nix];

  wayland.windowManager.hyprland = {
    enable = true;
    # package and portalPackage are backed by nixos
    package = null;
    portalPackage = null;

    settings = let
      apps = {
        ghostty = {
          name = "ghostty";
          class = "com.mitchellh.ghostty";
        };
        vscode = {
          name = "code";
          class = "code";
        };
        # slack = {
        #   name = "slack";
        #   class = "Slack";
        # };
        chrome = {
          name = "google-chrome-stable";
          class = "google-chrome";
        };
      };
      # wallPath = "~/dev/nix-config/home/alex/files/wallpapers";
      # wallpapers = [
      #   "${wallPath}/solarized_dots.jpg"
      #   "${wallPath}/solarized_triangle.jpg"
      # ];
    in {
      "$terminal" = "ghostty -e fish";

      "$mainMod" = "SUPER";

      # Taken from here : https://wiki.hyprland.org/Nvidia/
      # CLI debug to check if nvidia drivers are running:
      #
      # `nvidia-settings`
      # `glxinfo | egrep "OpenGL"`
      # `nvidia-smi`

      # env = [
      #   "LIBVA_DRIVER_NAME,nvidia"
      #   "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      # ];

      env = [
        "GTK_CURSOR_BLINK,1"
        "GTK_CURSOR_BLINK_TIME,1200"
      ];

      monitor = map ({value, ...}: "${value.name}, preferred, ${value.position}, ${value.scale}") (attrsToList monitors);

      exec-once = [
        (
          join " & "
          # Hyprland ecosystem
          ([
              "waybar"
              "swaync"
              "hyprpaper"
              "clipse -listen"
              "hyprctl setcursor ${user.cursor.theme} ${toString user.cursor.size}"
            ]
            ++
            # Apps
            (map ({value, ...}: value.name) (attrsToList apps)))
        )

        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP PATH"
      ];

      # Set wallpapers
      # Sometime services.hyprpaper isn't working...
      # execr-once = builtins.genList (i: let
      #   mon = builtins.elemAt monitors i;
      #   wallpaper = builtins.elemAt wallpapers i;
      # in "hyprctl hyprpaper reload ${mon.name}, \"${wallpaper}\"")
      # 2;

      # Default monitor for workspaces
      workspace =
        builtins.genList (i: "${toString (i + 1)}, monitor:${monitors.laptop.name}") 9
        ++ builtins.genList (i: "${toString (i + 1 + 10)}, monitor:${monitors.lg.name}") 9;

      bind =
        [
          # >>> Presets
          "$mainMod, u, movetoworkspace, 1, class:^(${apps.chrome.class})$"
          "$mainMod, u, movetoworkspace, 11, class:^(${apps.ghostty.class})$"
          "$mainMod, u, workspace, 1"
          "$mainMod, u, workspace, 11"

          "$mainMod, i, movetoworkspace, 2, class:^(${apps.chrome.class})$"
          # "$mainMod, i, movetoworkspace, 12, class:^(Slack)$"
          "$mainMod, i, movetoworkspace, 12, class:^(${apps.chrome.class})$"
          "$mainMod, i, workspace, 2"
          "$mainMod, i, workspace, 12"

          "$mainMod, o, movetoworkspace, 3, class:^(${apps.ghostty.class})$"
          "$mainMod, o, movetoworkspace, 13, class:^(${apps.vscode.class})$"
          "$mainMod, o, workspace, 3"
          "$mainMod, o, workspace, 13"

          "$mainMod, p, movetoworkspace, 4, class:^(${apps.ghostty.class})$"
          "$mainMod, p, movetoworkspace, 14, class:^(${apps.chrome.class})$"
          "$mainMod, p, workspace, 4"
          "$mainMod, p, workspace, 14"
          # <<< Presets

          # Apps
          "$mainMod, E, exec, nautilus"
          "$mainMod, G, exec, $terminal"
          "$mainMod, W, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, T, togglefloating,"
          "$mainMod, SPACE, execr, wofi --show drun"
          "$mainMod, C, exec, kitty --class clipse -e clipse"

          # Movements
          "$mainMod, h, movefocus, l"
          "$mainMod, j, movefocus, d"
          "$mainMod, k, movefocus, u"
          "$mainMod, l, movefocus, r"

          "$mainMod CTRL, h, swapwindow, l"
          "$mainMod CTRL, l, swapwindow, r"
          "$mainMod CTRL, k, swapwindow, u"
          "$mainMod CTRL, j, swapwindow, d"
        ]
        ++ builtins.genList (i: "$mainMod SHIFT, ${toString i}, movetoworkspace, ${toString i}") 9;

      binde = [
        "$mainMod CTRL, h, moveactive, -50 0  "
        "$mainMod CTRL, l, moveactive, 50 0  "
        "$mainMod CTRL, k, moveactive, 0 -50  "
        "$mainMod CTRL, j, moveactive, 0 50"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # TODO: try that for screen brightness, need to install `brightnessctl`
      # binde = , XF86MonBrightnessUp, exec, brightnessctl set +15%
      # binde = , XF86MonBrightnessDown, exec, brightnessctl set 15%-

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      windowrulev2 = [
        # files
        "float, class:(org.gnome.Nautilus)"
        "size 50% 50%, class:(org.gnome.Nautilus)"
        "stayfocused, class:(org.gnome.Nautilus)"

        # clipboard manager
        "float, class:(clipse)"
        "size 50% 50%, class:(clipse)"
        "stayfocused, class:(clipse)"

        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 8;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = borderActiveColor;
        "col.inactive_border" = borderInativeColor;

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 0;
        rounding_power = 2;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = "yes";

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      };

      # https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        kb_layout = "us";

        follow_mouse = 1;

        repeat_rate = 55;
        repeat_delay = 200;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        natural_scroll = true;

        touchpad = {
          natural_scroll = true;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      # gestures = {
      #   workspace_swipe = false;
      # };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
    };
  };

  home.pointerCursor = {
    name = user.cursor.theme;
    size = user.cursor.size;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.${user.cursor.pkgs};
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = user.cursor.theme;
      size = user.cursor.size;
      package = pkgs.${user.cursor.pkgs};
    };
  };

  # Notifications daemon
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./swaync.json);
    style = builtins.readFile ./swaync.css;
  };

  services.hyprpaper = {
    enable = true;
    settings = let
      # TODO: Put this in the global config.
      path = "~/dev/nix-config/home/alex/files/wallpapers";
      dots_img = "${path}/solarized_dots.jpg";
      triangle_img = "${path}/solarized_triangle.jpg";
    in {
      ipc = "on";
      preload = [dots_img triangle_img];
      wallpaper = [
        "${monitors.laptop.name},${dots_img}"
        "${monitors.lg.name},${triangle_img}"
      ];
    };
  };

  home.packages = with pkgs; [
    clipse
    wl-clipboard
    hyprshot
    nautilus
    hyprpaper # services.hyprpaper doesn't seems to run launch hyprpaper
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
