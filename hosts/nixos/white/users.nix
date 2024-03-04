{
  vars,
  pkgs,
  config,
  utils,
  ...
}: let
  inherit (utils) ifTheyExist;
in {
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    defaultUserShell = pkgs.fish;
    extraGroups =
      [
        "networkmanager"
        "wheel"
        "video"
        "audio"
      ]
      ++ ifTheyExist config.users.groups [
        "docker"
        "git"
      ];
  };
}
