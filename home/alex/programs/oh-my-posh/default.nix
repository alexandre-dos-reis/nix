{
  pkgs,
  inputs,
  ...
}: {
  programs.oh-my-posh = {
    enable = true;
    # enableFishIntegration = true;
    enableNushellIntegration = true;
    # https://ohmyposh.dev/docs/themes#quick-term
    # useTheme = "smoothie";
    # useTheme = "amro";
    settings = builtins.fromJSON (builtins.readFile ./config.json);
  };
}
