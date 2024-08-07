pkgs:
pkgs.writeShellApplication {
  name = "hello";
  runtimeInputs = with pkgs; [cowsay lolcat];
  text = ''
    echo "hello world" | cowsay | lolcat
  '';
}
