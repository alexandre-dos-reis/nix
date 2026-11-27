{useNixGL, ...}: {
  imports =
    [
      ../home.nix
    ]
    ++ (
      if !useNixGL
      then [./hyprland.nix]
      else []
    );
}
