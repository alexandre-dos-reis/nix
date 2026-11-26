{ config, ... }:
{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Rex terminals announce TERM=xterm-rex (the entry that carries Smulx /
    # Setulc, i.e. undercurl + colored underlines). Rex only claims that name
    # once this guard is in place, so that the name never reaches an ssh host
    # that has no such terminfo entry. The file is written and owned by
    # "rex terminfo setup"; see "rex terminfo status".
    includes = [ "${config.home.homeDirectory}/.config/rex/ssh_config" ];

    settings."*" = {
      identityFile = "~/.ssh/id_ed25519";
      addKeysToAgent = "yes";
      forwardAgent = false;
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
