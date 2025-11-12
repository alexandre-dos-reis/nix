{pkgs, ...}: {
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      tmux-navigator
      lightline-vim
    ];
    extraConfig = builtins.readFile ./config.vim;
  };
}
