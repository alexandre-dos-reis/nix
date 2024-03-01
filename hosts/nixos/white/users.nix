{
  vars,
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
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
      ++ ifTheyExist [
        "docker"
        "git"
      ];
  };
}
