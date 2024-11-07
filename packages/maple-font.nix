{
  lib,
  stdenv,
  unzip,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "MapleMono-NF";
  version = "7.0-beta29";
  src = fetchurl {
    url = "https://github.com/subframe7536/Maple-font/releases/download/v${version}/${pname}.zip";
    sha256 = "sha256-PSVENrrN14kFKrtfd5RORsOeZKoqNGe0FfZvn0I+e2Y=";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  sourceRoot = ".";
  nativeBuildInputs = [unzip];
  installPhase = ''
    find . -name '*.ttf'    -exec install -Dt $out/share/fonts/truetype {} \;
    find . -name '*.otf'    -exec install -Dt $out/share/fonts/opentype {} \;
    find . -name '*.woff2'  -exec install -Dt $out/share/fonts/woff2 {} \;
  '';

  meta = with lib; {
    homepage = "https://github.com/subframe7536/Maple-font";
    description = ''
      Open source Nerd Font font with round corner and ligatures for IDE and command line
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
