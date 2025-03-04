{
  programs = {
    direnv = {
      enable = true;
      silent = true;
      # enableFishIntegration = true;
      # enableNushellIntegration = true;
      nix-direnv.enable = true;
      config = {
        # https://direnv.net/man/direnv.toml.1.html
        hide_env_diff = true;
      };
    };
  };
}
