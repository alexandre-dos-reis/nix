{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
    };
    settings = {
      mgr = {
        ratio = [1 3 4];
        show_hidden = true;
      };
      preview = {
        max_width = 2000;
      };
    };
    keymap = {
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
      ];
    };
  };
}
