{
  inputs,
  pkgs,
  ...
}: {
  # Enable Hyprland caches
  # https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  nix.settings.substituters = ["https://hyprland.cachix.org"];
  nix.settings.trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  # Hyprland
  # https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Force app to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
