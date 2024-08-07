inputs: let
  inherit (import ./constants.nix) linux darwin x84_64 aarch64;
  inherit (inputs) nixgl;
  mkHost = args:
    {
      overlays = [];
      isNixGlWrapped = false;
      xdgDataFileEnabled = false;
      isManagedByHomeManager = false;
    }
    // args;
in {
  white = mkHost {
    hostname = "white";
    path = "white";
    arch = x84_64;
    os = linux;
  };
  work = mkHost {
    hostname = "kavval";
    path = "work";
    arch = x84_64;
    os = linux;
    overlays = [nixgl.overlay];
    isNixGlWrapped = true;
    xdgDataFileEnabled = true;
    isManagedByHomeManager = true;
  };
  siliconWork = mkHost {
    hostname = "kavval-silicon";
    path = "siliconWork";
    arch = aarch64;
    os = darwin;
  };
  mbp2012 = mkHost {
    hostname = "mbp2012";
    path = "mbp2012";
    arch = x84_64;
    os = darwin;
  };
}
