{...}: {
  # System-level nh cleanup: runs as root and cleans the *system* profile
  # (/nix/var/nix/profiles/system). The home-manager programs.nh.clean only
  # cleans the user profile, so without this, system generations pile up.
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10 --keep-since 0";
  };
}
