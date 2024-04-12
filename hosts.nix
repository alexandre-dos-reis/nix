let
  inherit (import ./constants.nix) linux darwin x84_64 aarch64;
in {
  white = {
    hostname = "white";
    path = "white";
    arch = x84_64;
    os = linux;
  };
  work = {
    hostname = "kavval";
    path = "work";
    arch = x84_64;
    os = linux;
  };
  siliconWork = {
    hostname = "kavval-silicon";
    path = "siliconWork";
    arch = aarch64;
    os = darwin;
  };
  mbp2012 = {
    hostname = "mbp2012";
    path = "mbp2012";
    arch = x84_64;
    os = darwin;
  };
}
