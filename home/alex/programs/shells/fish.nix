{
  utils,
  pkgs,
  user,
  inputs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  # https://github.com/alexandre-dos-reis/dotfiles/blob/main/dot_config/private_fish/config.fish
  # https://discourse.nixos.org/t/managing-fish-plugins-with-home-manager/22368
  # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1782971499

  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting ""
      set -gx TERM xterm-256color
      set -gx EDITOR ${user.editor}
      set -gx PATH bin $PATH
      set -gx PATH ~/bin $PATH
      set -gx PATH ~/.local/bin $PATH
      set -gx PATH ~/.pulumi/bin $PATH
      set -gx PATH ${user.npm.packages.path}/bin $PATH

      set -g theme_color_scheme terminal-dark
      set -g fish_prompt_pwd_dir_length 1
      set -g theme_display_user yes
      set -g theme_hide_hostname no
      set -g theme_hostname always

      fish_vi_key_bindings
      function fish_mode_prompt; end

      bind \cf "tmux-sessionizer"

      if type -q kubens
        source ${inputs.kubectx}/completion/kubens.fish
      end

      if type -q flux
        ${builtins.readFile ./completions/fluxcd.fish}
      end
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
      kns = "kubens";
      kx = "kubectx";
    };

    # https://search.nixos.org/packages?channel=unstable&show=fishPlugins.z&from=0&size=50&sort=relevance&type=packages&query=fishPlugins
    plugins = with pkgs.fishPlugins;
      [
        # {
        #   name = "tide";
        #   src = tide.src;
        # }
        {
          name = "autopair";
          src = autopair.src;
        }
        {
          # TODO: Replace this plugin with personal aliases for use with other shells.
          # https://gist.github.com/spitfire05/103324f015d12c661f5da9e329852ad0
          name = "git";
          src = plugin-git.src;
        }
        {
          name = "z";
          src = z.src;
        }
        {
          name = "sponge";
          src = sponge.src;
        }
      ]
      ++ (
        if isDarwin
        then [
          {
            name = "ssh-agent-macos";
            src = inputs.ssh-agent-macos;
          }
        ]
        else [
          {
            name = "fish-ssh-agent";
            src = inputs.fish-ssh-agent;
          }
        ]
      );
  };
}
