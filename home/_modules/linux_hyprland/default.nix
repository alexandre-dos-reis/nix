{
  pkgs,
  user,
  ...
}: {
  # TODO: https://www.youtube.com/watch?v=zt3hgSBs11g
  # Example of script using pid
  # https://www.emadelsaid.com/Open%20application%20in%20workspace%20Hyprland/
  # https://blogs.kde.org/2024/10/09/cursor-size-problems-in-wayland-explained/

  # wayland.windowManager.hyprland = {
  # TODO: Rewrite hyprland.conf the nix way
  # For now just tweak the config file in `~/.config/hypr/hyprland.conf`
  #   enable = true;
  # };

  home.pointerCursor = {
    hyprcursor.enable = true;
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.banana-cursor;
    name = "Banana";
    # package = pkgs.bibata-cursors;
    # name = "Bibata-Modern-Classic";
    size = user.cursorSize;
  };
  gtk = {enable = true;};

  # Notifications daemon
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./swaync.json);
    style = builtins.readFile ./swaync.css;
  };

  services.hyprpaper = {
    enable = true;
    settings = let
      path = "/home/alex/dev/nix-config/home/alex/programs/hyprland/wallpapers";
      dots_img = "${path}/solarized_dots.jpg";
      triangle_img = "${path}/solarized_triangle.jpg";
    in {
      ipc = "on";
      preload = [dots_img triangle_img];
      wallpaper = ["DP-4,${triangle_img}" "eDP-1,${dots_img}"];
    };
  };

  home.packages = with pkgs; [
    clipse
    wl-clipboard
    hyprshot
    nautilus
    hyprpaper # services.hyprpaper doesn't seems to run launch hyprpaper
  ];

  # App launcher
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./wofi.css;
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

  # Status bar
  programs.waybar = {
    # https://github.com/Alexays/Waybar/wiki/Module:-Hyprland
    enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        # modules-center = ["hyprland/window"];
        modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "battery" "clock" "tray"];

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          # I'm using icons just to rename workspaces
          format = "{icon}";
          format-icons = let
            work = "Work";
            com = "Com";
            share = "Share";
            review = "Review";
          in {
            "1" = work;
            "2" = com;
            "3" = share;
            "4" = review;
            "11" = work;
            "12" = com;
            "13" = share;
            "14" = review;
          };
          disable-scroll = true;
          show-special = true;
          # special-visible-only = true;
          persistent-workspaces = {
            "eDP-1" = [
              1
              2
              3
              4
            ];
            "DP-4" = [
              11
              12
              13
              14
            ];
          };
        };
        "hyprland/language" = {
          "format" = "{}";
          "format-en" = "Eng";
          "format-fr" = "Fra";
        };
        "pulseaudio" = {
          "max-volume" = 100;
          "format" = "{volume}{icon}";
          "tooltip" = false;
          "format-muted" = "Muted";
          "on-click" = "pamixer -t";
          "on-scroll-up" = "pamixer -i 2";
          "on-scroll-down" = "pamixer -d 2";
          "scroll-step" = 2;
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
        };
      };
    };
  };
}
