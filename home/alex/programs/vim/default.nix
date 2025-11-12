{pkgs, ...}: {
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./config.vim;
    plugins = with pkgs.vimPlugins; [
      tmux-navigator
    ];
  };
}
