{...}: {
  # Enable the devenv cache. Required: devenv is pulled from its upstream flake
  # rather than nixpkgs (see the `devenv` input in flake.nix), so without this
  # substituter it would be compiled from source.
  # https://devenv.sh/getting-started/
  nix.settings = {
    substituters = ["https://devenv.cachix.org"];
    trusted-substituters = ["https://devenv.cachix.org"];
    trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
  };
}
