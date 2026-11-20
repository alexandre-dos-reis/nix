{pkgs, ...}: {
  # Fish as the login shell for every normal user.
  #
  # Neither herdr nor the Herdr app has a shell setting of its own: herdr-core
  # spawns the login shell recorded in passwd, so this is what makes their new
  # terminals open in fish. programs.fish.enable also registers fish in
  # /etc/shells, which chsh and some login paths require.
  #
  # The fish configuration itself lives in home/alex/programs/fish.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
