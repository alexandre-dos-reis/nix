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
    extraConfig = let
      mkAutopair = name: triggerChar: insertChar: ''
         {
          name: ${name}
          modifier: none
          keycode: "char_${triggerChar}"
          mode: [emacs vi_normal vi_insert]
          event: [
              { edit: InsertChar value: "${triggerChar}" }
              { edit: InsertChar value: "${insertChar}" }
              { edit: MoveLeft }
          ]
        }
      '';
    in ''
      ${builtins.readFile ./completions.nu}

      $env.config.show_banner = false
      $env.config.table.mode = "thin"

      let vi_normal_icon = "ℕ "
      let vi_insert_icon = "> "

      $env.config.edit_mode = "vi"
      $env.PROMPT_INDICATOR_VI_NORMAL = $vi_normal_icon
      $env.PROMPT_INDICATOR_VI_INSERT = $vi_insert_icon
      $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $vi_normal_icon
      $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $vi_insert_icon

      $env.config.buffer_editor = "${user.editor}"
      $env.config.keybindings = [
        ${mkAutopair "AutoParen" "(" ")"}
        ${mkAutopair "AutoSquared" "[" "]"}
        ${mkAutopair "AutoCurly" "{" "}"}
        ${mkAutopair "AutoDoublequote" "\\\"" "\\\""}
        ${mkAutopair "AutoSinglequote" "'" "'"}
      ]
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
