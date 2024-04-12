pkgs: pkgs.writeShellApplication {
      name = "mkdevdir";
      text = ''
        mkdir ~/dev/"$1"
      '';
}
