pkgs: {
  username = "alex";
  email = "ajm.dosreis.daponte@gmail.com";
  fullname = "Alexandre Dos Reis";
  machines = {
    white.name = "white";
    work.name = "kavval";
    mbp2012.name = "mbp2012";
  };
  utils = {
    isLinux = pkgs.stdenv.isLinux;
    isDarwin = pkgs.stdenv.isDarwin;
    isNixOs = builtins.pathExists /etc/nixos;
  };
}
