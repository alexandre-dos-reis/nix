{pkgs, ...}: {
  programs.yazi = {
    # https://mynixos.com/home-manager/options/programs.yazi
    enable = true;
    enableFishIntegration = true;
    initLua = ./init.lua;
    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
      git = pkgs.yaziPlugins.git;
      full-border = pkgs.yaziPlugins.full-border;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
    };
    settings = {
      mgr = {
        ratio = [1 3 4];
        show_hidden = true;
      };
      preview = {
        max_width = 1500;
      };
    };
    keymap = {
      # https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml
      mgr.prepend_keymap = [
        {
          on = "<Enter>";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "o";
          run = "hidden toggle";
          desc = "Toggle the visibility of hidden files";
        }
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
      ];
    };
  };
}
