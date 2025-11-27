{useNixGl, ...}: {
  imports =
    [
      ./home.nix
    ]
    ++ (
      if !useNixGl
      then [./hyprland]
      else []
    );
}
