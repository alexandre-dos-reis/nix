{
  pkgs,
  config,
  inputs,
  ...
}: let
  constants = import ../../constants.nix;
  colors = constants.colors.palette;

  # Lua API stubs (hl.meta.lua) that ship with Hyprland, for lua_ls / LSP.
  hyprStubs = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/stubs";

  # Absolute path to the hand-maintained Lua config in this repo, symlinked live
  # so edits apply on `hyprctl reload` without a rebuild.
  repoLuaConfig = "${config.home.homeDirectory}/dev/nix-config/home/alex/linux/hyprland/config.lua";

  monitors = {
    laptop.name = "eDP-1";
    lg.name = "DP-3"; # Plugged on the top left usbc input.
  };
in {
  imports = [./waybar.nix];

  home.file.".config/hypr/scripts/moveToWorkspace".source = ./scripts/moveToWorkspace.sh;

  wayland.windowManager.hyprland = {
    # Hyprland 0.55+ Lua config. The actual config is hand-written in config.lua;
    # home-manager only generates a thin hyprland.lua (systemd hook + require).
    configType = "lua";
    enable = true;
    # package and portalPackage are backed by nixos
    package = null;
    portalPackage = null;

    settings = {};

    # Load the hand-maintained config. config.lua is symlinked into
    # ~/.config/hypr below, and require() resolves it from there.
    extraConfig = ''
      package.path = package.path .. ";${config.home.homeDirectory}/.config/hypr/?.lua"
      require("config")
    '';
  };

  # Live-editable Lua config: edits to the repo file apply on `hyprctl reload`.
  xdg.configFile."hypr/config.lua".source =
    config.lib.file.mkOutOfStoreSymlink repoLuaConfig;

  # --- LSP support for editing config.lua ---
  # Expose the Hyprland Lua stubs at a stable path and point lua_ls at them.
  xdg.configFile."hypr/stubs".source = hyprStubs;
  xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
    "runtime.version" = "LuaJIT";
    "workspace.library" = [hyprStubs];
    "diagnostics.globals" = ["hl"];
  };

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

  # Notifications daemon
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./swaync.json);
    style = builtins.readFile ./swaync.css;
  };

  home.file.".config/hypr/files/solarized_dots.jpg".source = ../../files/wallpapers/solarized_dots.jpg;
  home.file.".config/hypr/files/solarized_triangle.jpg".source = ../../files/wallpapers/solarized_triangle.jpg;

  services.hyprpaper = {
    enable = true;
    settings = let
      path = "~/.config/hypr/files";
      dots_img = "${path}/solarized_dots.jpg";
      triangle_img = "${path}/solarized_triangle.jpg";
    in {
      wallpaper = [
        {
          monitor = monitors.laptop.name;
          path = triangle_img;
        }
        {
          monitor = monitors.lg.name;
          path = dots_img;
        }
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
