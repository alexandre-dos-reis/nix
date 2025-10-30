{pkgs, ...}: {
  home.packages = with pkgs; [
    podman
    podman-compose
    freerdp
    (python3.withPackages
      (ps: [ps.pyside6]))
  ];
}
