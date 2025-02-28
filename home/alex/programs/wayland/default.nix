{pkgs, ...}: {
  # TODO: https://www.youtube.com/watch?v=zt3hgSBs11g
  # For now just tweak the config file in `~/.config/hypr/hyprland.conf`

  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };

  # App launcher
  programs.wofi.enable = true;
  # Status bar
  programs.waybar.enable = true;

  # TUI-based clipboard manager
  home.packages = [
    pkgs.clipse
  ];
}
