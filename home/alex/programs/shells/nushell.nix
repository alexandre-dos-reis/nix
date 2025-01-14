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
      $env.config.buffer_editor = "nvim"
      $env.config.edit_mode = "vi"
      $env.PROMPT_INDICATOR_VI_NORMAL = "n "
      $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = "n "
      $env.PROMPT_INDICATOR_VI_INSERT = "> "
      $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = "> "
    '';

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
      d = "docker";
      dcp = "docker compose";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      ffn = "ff | xargs nvim";
      s = "sudo env PATH=\"$PATH\"";
      k = "kubectl";
      kns = "kubens";
      kx = "kubectx";

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
