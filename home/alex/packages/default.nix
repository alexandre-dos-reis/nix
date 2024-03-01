{pkgs, ...}: {
  imports = [
    ./kavval.nix
  ];

  home.packages = with pkgs; [
    dust
  ];
}
