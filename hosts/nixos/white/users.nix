{ globals, pkgs, ...}:
let 
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {

  users.users.${globals.username} = {
    isNormalUser = true;
    description = globals.username;
    defaultUserShell = pkgs.fish;
    extraGroups = [ 
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ] ++ [
      "docker"
      "git"
    ];
  };
}
