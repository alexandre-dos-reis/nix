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
      $env.config.shell_integration = true
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
      f = "~/bin/tmux-sessionizer";
      fw = "~/bin/tmux-windownizer";
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
      gcb = "git checkout -b";
      gp = "git push";
      gpf = "git push --force";
      gl = "git pull";
    };
  };
}
