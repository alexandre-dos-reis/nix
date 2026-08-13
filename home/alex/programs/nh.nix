{config, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 20 --keep-since 0";
    flake = "${config.home.homeDirectory}/dev/nix-config";
  };
}
