let
  inherit (import ./constants.nix) linux darwin x84_64 aarch64;
in {
  white = {
    hostname = "white";
    folder = "white";
    arch = x84_64;
    os = linux;
  };
  work = {
    hostname = "kavval";
    folder = "work";
    arch = x84_64;
    os = linux;
  };
  siliconWork = {
    hostname = "kavval-silicon";
    folder = "siliconWork";
    arch = aarch64;
    os = darwin;
  };
  mbp2012 = {
    hostname = "mbp2012";
    folder = "mbp2012";
    arch = x84_64;
    os = darwin;
  };
}
