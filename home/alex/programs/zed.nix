{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;

      current_line_highlight = "all";
      selection_highlight = false;
      theme = "Ayu Dark";
      lsp_highlight_debounce = 9999999999;
    };
  };
}
