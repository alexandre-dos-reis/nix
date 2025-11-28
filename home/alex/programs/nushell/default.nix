{pkgs, ...}: let
  constants = import ../../constants.nix;
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

      $env.config.buffer_editor = "${constants.editor}"
      $env.config.keybindings = [
        ${mkAutopair "AutoParen" "(" ")"}
        ${mkAutopair "AutoSquared" "[" "]"}
        ${mkAutopair "AutoCurly" "{" "}"}
        ${mkAutopair "AutoDoublequote" "\\\"" "\\\""}
        ${mkAutopair "AutoSinglequote" "'" "'"}
      ]
    '';
    shellAliases =
      constants.shellAliases
      // {
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
