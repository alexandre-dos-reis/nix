{config, ...}: {
  # temporary overlay
  config.nixpkgs.overlays = [
    # See https://github.com/NixOS/nixpkgs/issues/353119
    (final: prev: {
      _7zz = prev._7zz.override {useUasm = true;};
    })
  ];
}
