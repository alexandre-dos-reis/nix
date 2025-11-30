{useNixGL, ...}: {
  imports =
    [
      ../home.nix
      ./keyboard.nix
    ]
    ++ (
      if !useNixGL
      then [./hyprland]
      else []
    );
}
