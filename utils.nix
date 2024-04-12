host: {
  system = "${host.arch}-${host.os}";
  ifTheyExist = groupsIn: groups: builtins.filter (group: builtins.hasAttr group groupsIn) groups;
  getHomeDir = {
    isDarwin,
    username,
  }:
    if isDarwin
    then "/Users/${username}"
    else "/home/${username}";
}
