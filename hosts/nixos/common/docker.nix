{users, ...}: {
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = map (u: u.username) users;
}
