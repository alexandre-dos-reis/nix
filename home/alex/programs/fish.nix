{
  utils,
  pkgs,
  ...
}: {
  # https://github.com/alexandre-dos-reis/dotfiles/blob/main/dot_config/private_fish/config.fish
  # https://discourse.nixos.org/t/managing-fish-plugins-with-home-manager/22368
  programs.fish = {
    enable = true;

    shellInit = ''
      set fish_greeting ""
      set -gx TERM xterm-256color
      set -gx EDITOR nvim
      set -gx PATH bin $PATH
      set -gx PATH ~/bin $PATH
      set -gx PATH ~/.local/bin $PATH

      set -g theme_color_scheme terminal-dark
      set -g fish_prompt_pwd_dir_length 1
      set -g theme_display_user yes
      set -g theme_hide_hostname no
      set -g theme_hostname always

      fish_vi_key_bindings
    '';

    shellAbbrs = {
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
      cm = "chezmoi";
      cme = "chezmoi edit --apply";
      d = "docker";
      dcp = "docker compose";
      ff = "fzf --preview 'bat --style=numbers --color=always {}'";
      ffn = "ff | xargs nvim";
      k = "kubectl";
    };

    # https://search.nixos.org/packages?channel=unstable&show=fishPlugins.z&from=0&size=50&sort=relevance&type=packages&query=fishPlugins
    plugins = with pkgs.fishPlugins;
      [
        {
          name = "tide";
          src = tide.src;
        }
        {
          name = "autopair";
          src = autopair.src;
        }
        {
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
      ];
  };
}
