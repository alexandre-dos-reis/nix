inputs: let
  inherit (import ./constants.nix) linux darwin x84_64 aarch64;
  inherit (inputs) nixgl;
  base = {
    overlays = [];
    isNixGlWrapped = false;
    xdgDataFileEnabled = false;
  };
in {
  white =
    base
    // {
      hostname = "white";
      path = "white";
      arch = x84_64;
      os = linux;
    };
  work =
    base
    // {
      hostname = "kavval";
      path = "work";
      arch = x84_64;
      os = linux;
      overlays = [nixgl.overlay];
      isNixGlWrapped = true;
      xdgDataFileEnabled = true;
    };
  siliconWork =
    base
    // {
      hostname = "kavval-silicon";
      path = "siliconWork";
      arch = aarch64;
      os = darwin;
    };
  mbp2012 =
    base
    // {
      hostname = "mbp2012";
      path = "mbp2012";
      arch = x84_64;
      os = darwin;
    };
}
