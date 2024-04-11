let
  x84_64 = "x86_64";
  aarch64 = "aarch64";
  darwin = "darwin";
  linux = "linux";
in {
  inherit x84_64 aarch64 darwin linux;
  systems = [
    "${x84_64}-${linux}"
    "${aarch64}-${linux}"
    "${x84_64}-${darwin}"
    "${aarch64}-${darwin}"
  ];
}
