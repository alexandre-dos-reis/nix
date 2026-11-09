{pkgs-unstable, ...}: {
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    package = pkgs-unstable.mise;
  };
}
