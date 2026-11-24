# Development libraries (headers + .pc files) available system-wide, for building
# GTK programs (Renux, …) straight from a normal shell.
#
# Nix equivalents of the Debian `-dev` packages:
#   libgtk-4-dev         -> gtk4
#   libadwaita-1-dev     -> libadwaita
#   librsvg2-dev         -> librsvg
#   libpoppler-glib-dev  -> poppler (nixpkgs builds it with the glib frontend)
#   libepoxy-dev         -> libepoxy
#
# In nixpkgs the headers and pkg-config files live in the `dev` output of the
# same package, and a `.pc` file names its dependencies through `Requires:`
# (gtk4 -> glib-2.0, cairo, …). Those come from the propagated build inputs,
# which `environment.systemPackages` does not pull in, so the whole propagation
# closure is collected here and joined into one tree to search.
{
  pkgs,
  lib,
  ...
}: let
  devLibs = with pkgs; [
    gtk4
    libadwaita
    librsvg
    poppler
    libepoxy
  ];

  # Every dev output in the closure, under a single prefix.
  devEnv = pkgs.buildEnv {
    name = "dev-libraries";
    paths = map lib.getDev (lib.closePropagation devLibs);
    ignoreCollisions = true;
  };
in {
  environment.systemPackages = [pkgs.pkg-config] ++ devLibs;

  environment.sessionVariables = {
    PKG_CONFIG_PATH = [
      "${devEnv}/lib/pkgconfig"
      "${devEnv}/share/pkgconfig"
    ];
    # Headers included directly, outside of pkg-config: Renux runs
    # `zig translate-c` on a header that does `#include <epoxy/gl.h>`, and that
    # step is given no pkg-config flags. Zig's C frontend honours C_INCLUDE_PATH.
    C_INCLUDE_PATH = ["${devEnv}/include"];
  };
}
