{useNixGL, ...}: {
  imports =
    [
      ../home.nix
    ]
    ++ (
      if !useNixGL
      then [./hyprland.nix ./wayle.nix ./rofi.nix]
      else []
    );
}
