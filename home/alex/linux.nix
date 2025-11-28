{useNixGL, ...}: {
  imports =
    [
      ./home.nix
    ]
    ++ (
      if !useNixGL
      then [./hyprland]
      else []
    );
}
