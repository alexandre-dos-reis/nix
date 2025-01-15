{
  utils,
  pkgs,
  user,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  home.packages = with pkgs; [
    carapace # completions
  ];

  programs.nushell = {
    enable = true;
    extraConfig = builtins.readFile ./config.nu;
    shellAliases = {
      v = "nvim";
      t = "tmux";
      ta = "tmux attach";
      tk = "tmux kill-session";
      ll = "ls -l";
      lla = "ls -la";
      c = "clear";
      b = "bat -p";
      cs = "~/bin/cht.sh";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      ffn = "ff | xargs nvim";
      s = "sudo env PATH=\"$PATH\"";

      d = "docker";
      dcp = "docker compose";

      k = "kubectl";
      kns = "kubens";
      kx = "kubectx";

      g = "git";
      gst = "git status";
      ga = "git add";
      gcm = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gp = "git push";
      gl = "git pull";
    };
  };
}
