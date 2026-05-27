{
  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = {
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
