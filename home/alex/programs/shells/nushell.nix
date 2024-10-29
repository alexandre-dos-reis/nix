{
  utils,
  pkgs,
  user,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  programs.nushell = {
    enable = true;

    extraConfig = ''
      $env.config.show_banner = false
    '';

    shellAliases = {
      v = "nvim";
      t = "tmux";
      ta = "tmux attach";
      tk = "tmux kill-session";
      ll = "exa -l -g --icons";
      lla = "ll --all";
      llt = "ll --tree";
      c = "clear";
      b = "bat -p";
      cs = "~/bin/cht.sh";
      d = "docker";
      dcp = "docker compose";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      ffn = "ff | xargs nvim";
      s = "sudo env PATH=\"$PATH\"";
      k = "kubectl";

      # git
      gst = "git status";
      ga = "git add";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gcne = "git commit --amend --no-edit";
      gco = "git checkout";
      gcb = "git checkout -b";
      gp = "git push";
      gpf = "git push --force";
      gl = "git pull";
    };
  };
}
