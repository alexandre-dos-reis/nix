{config, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10";
    flake = "${config.home.homeDirectory}/dev/nix-config";
  };
}
