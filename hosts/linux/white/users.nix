{
  users,
  pkgs,
  config,
  utils,
  ...
}: let
  inherit (utils) ifTheyExist;
  inherit (users.alex) username;
in {
  users.users.${username} = {
    isNormalUser = true;
    description = username;
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
