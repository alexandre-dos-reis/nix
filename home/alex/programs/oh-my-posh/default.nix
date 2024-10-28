{
  pkgs,
  inputs,
  ...
}: {
  programs.oh-my-posh = {
    enable = true;
    enableNushellIntegration = true;
    # https://ohmyposh.dev/docs/themes#quick-term
    # useTheme = "smoothie";
    # useTheme = "tonybaloney";
    settings = builtins.fromJSON (builtins.readFile ./config.json);
  };
}
