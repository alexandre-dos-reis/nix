{user, ...}: let
  colors = user.colors.palette;
  cyan = colors.cyan500-hex;
  yellow = colors.yellow500-hex;
  white = colors.base2-hex;
in {
  programs.waybar = {
    # https://github.com/Alexays/Waybar/wiki/Module:-Hyprland
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["clock"];
        modules-center = ["hyprland/workspaces"];
        # modules-center = ["hyprland/window"];
        modules-right = ["hyprland/language" "custom/weather" "pulseaudio" "network" "memory" "cpu" "battery"];

        clock = {
          format = "<span color='${cyan}'>{:%A %H:%M %d %b}</span>";
        };
        "memory" = {
          "format" = "<span color='${white}'>r{}%</span> ";
        };
        "cpu" = {
          "format" = "<span color='${white}'>c{}%</span> ";
        };

        network = {
          "format" = "{ifname}";
          "format-wifi" = "";
          "format-ethernet" = "{ifname}/{cidr}";
          "format-disconnected" = "";
          "tooltip-format" = "{ifname} via {gwaddr}";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
          "tooltip-format-ethernet" = "{ifname} ";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 50;
        };

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          # I'm using icons just to rename workspaces
          format = "{icon}";
          format-icons = let
            # work = "Work";
            # com = "Com";
            # share = "Share";
            # review = "Review";
            icon = "";
          in {
            "1" = icon;
            "2" = icon;
            "3" = icon;
            "4" = icon;
            "11" = icon;
            "12" = icon;
            "13" = icon;
            "14" = icon;
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

        battery = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = ["" "" "" "" ""];
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

    style = ''
      * {
        border: none;
        font-family: ${user.font};
        font-weight: 800;
        font-size: 20px;
        min-height: 0;
      }

      window#waybar {
        background: none;
        margin: 0px;
        padding: 0 5px;
      }

      tooltip {
        background: rgba(0, 43, 54, 0.9);
        color: #839496;
      }

      #workspaces button {
        border: none;
        transition-duration: 0.3s;
        background: none;
        box-shadow: inherit;
        text-shadow: inherit;
        margin-top: -4px;
        margin-bottom: -4px;
      }

      #workspaces button {
        color: ${white};
      }

      #workspaces button:hover {
        color: #268bd2;
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
      #cpu,
      #cava,
      #keyboard-state,
      #idle_inhibitor,
      #custom-power {
        background: none;
        padding: 0px 10px;
        margin: 0px;
        margin-top: 5px;
      }

      #workspaces {
        margin-left: 4px;
        padding-right: 4px;
        padding-left: 0px;
      }

      #language {
        color: ${cyan};
        min-width: 24px;
      }

      #keyboard-state {
        background: none;
        color: #b58900;
        border: none;
      }

      #custom-updates {
        background: rgba(0, 43, 54, 0.9);
        color: #268bd2;
      }

      #window {
        background: rgba(0, 43, 54, 0.9);
        margin-left: 30px;
        margin-right: 30px;
      }

      #custom-playerctl {
        background: rgba(0, 43, 54, 0.9);
        color: #b58900;
      }

      #cava {
        background: rgba(0, 43, 54, 0.9);
        color: #cb4b16;
        margin-left: 4px;
      }


      #network {
        color: #839496;
      }

      #battery,
      #pulseaudio.microphone,
      #pulseaudio {
        color: ${cyan};
      }

      #custom-weather {
        background: rgba(0, 43, 54, 0.9);
        color: #b58900;
        border-radius: 7px 0px 0px 7px;
      }

      #idle_inhibitor {
        background: rgba(0, 43, 54, 0.9);
        color: #839496;
        min-width: 18px;
      }

      #custom-power {
        background: rgba(0, 43, 54, 0.9);
        color: #dc322f;
        margin-left: 0px;
        margin-right: 4px;
        padding-right: 12px;
      }
    '';
  };
}
