{pkgs, ...}: let
  constants = import ../constants.nix;

  colors = constants.colors.palette;
  cyan = colors.cyan500-hex;
  yellow = colors.yellow500-hex;
  orange = colors.orange-hex;
  white = colors.base2-hex;
  blue = colors.blue500-hex;
  green = colors.green500-hex;
  violet = colors.violet500-hex;
in {
  home.packages = with pkgs; [
    wttrbar
    nerd-fonts.caskaydia-mono
  ];

  programs.waybar = {
    # https://github.com/Alexays/Waybar/wiki/Module:-Hyprland
    # Enable css in nix with treesitter: https://www.youtube.com/watch?v=v3o9YaHBM4Q
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "memory"
          "cpu"
          "disk"
          "battery"
        ];
        # modules-center = ["hyprland/workspaces"];
        modules-right = [
          # "hyprland/language"
          "pulseaudio"
          "network"
          "custom/weather"
          "clock"
        ];

        "custom/weather" = {
          "format" = "<span color='${green}'>{}°</span>";
          "tooltip" = true;
          "interval" = 3600;
          "exec" = "wttrbar --location blèves --nerd";
          "return-type" = "json";
        };
        clock = {
          format = "<span color='${white}'>{:%H:%M}</span>";
          format-alt = "{:%A, %B %d, %Y (%R)} ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        "memory" = {
          "format" = "<span color='${cyan}'> {}%</span> ";
        };
        "cpu" = {
          "format" = "<span color='${cyan}'> {}%</span> ";
        };
        "disk" = {
          "format" = "<span color='${cyan}'> {}%</span> ";
        };

        network = {
          "format" = "<span color='${violet}'>{ifname}</span>";
          "format-wifi" = "<span color='${violet}'>{essid} {icon}</span>";
          "format-ethernet" = "{ifname}/{cidr}";
          "format-disconnected" = "<span color='${violet}'>NO NETWORK</span>";
          "tooltip-format" = "{ifname} via {gwaddr}";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
          "tooltip-format-ethernet" = "{ifname} ";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 50;
          "format-icons" = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        };

        # "hyprland/workspaces" = {
        #   active-only = false;
        #   all-outputs = false;
        #   format = "{icon}";
        #   format-icons = let
        #     icon = "";
        #   in {
        #     "1" = icon;
        #     "2" = icon;
        #     "3" = icon;
        #     "4" = icon;
        #     "11" = icon;
        #     "12" = icon;
        #     "13" = icon;
        #     "14" = icon;
        #   };
        #   disable-scroll = true;
        #   show-special = true;
        #   persistent-workspaces = {
        #     "eDP-1" = [
        #       1
        #       2
        #       3
        #       4
        #     ];
        #     "DP-4" = [
        #       11
        #       12
        #       13
        #       14
        #     ];
        #   };
        # };
        # "hyprland/language" = {
        #   "format" = "<span color='${green}'>{}</span>";
        #   "format-en" = "Eng";
        #   "format-fr" = "Fra";
        # };

        battery = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "<span color='${cyan}'>{icon} {capacity}%</span>";
          "format-charging" = "<span color='${cyan}'> {capacity}%</span>";
          "format-plugged" = "<span color='${cyan}'> {capacity}%</span>";
          "format-alt" = "<span color='${cyan}'>{icon} {capacity}%</span>";
          "format-icons" = ["" "" "" "" ""];
        };
        "pulseaudio" = {
          "max-volume" = 100;
          "format" = "<span color='${yellow}'>{volume}% {icon}</span>";
          "tooltip" = false;
          "format-muted" = "<span color='${orange}'>Muted </span>";
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

    style = ''
      * {
        border: none;
      }

      window#waybar {
        background: none;
        margin: 0;
        padding: 0 5px;
        font-size: 18px;
        font-weight: 400;
        font-family: CaskaydiaMono Nerd Font;
      }

      tooltip {
        background: rgba(0, 43, 54, 0.9);
        color: ${cyan};
      }

      #workspaces button {
        transition-duration: 0.3s;
        background: none;
        box-shadow: inherit;
        text-shadow: inherit;
        font-weight: 800;
        font-family: ${constants.font};
        font-size: 30px;
        margin-top: -8px;
        margin-bottom: -8px;
      }

      #workspaces button {
        color: ${white};
      }

      #workspaces button:hover {
        color: ${blue};
      }

      #workspaces button.visible {
        color: ${yellow};
      }

      #language,
      #custom-updates,
      #custom-weather,
      #window,
      #custom-playerctl,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #workspaces,
      #tray,
      #memory,
      #disk,
      #cpu,
      #cava,
      #keyboard-state,
      #idle_inhibitor,
      #workspaces {
        background: none;
        padding: 0;
        margin: 10px 12px 5px;
      }

    '';
  };
}
