# Deps for kavval-core
{
  # FINISHERS
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = ["alex"];

  # https://github.com/Mic92/envfs
  # Allows executing FHS based programs on a non-FHS system
  # CAUTION: this seems usefull but freeze the host!
  # services.envfs.enable = true;

  # Some scripts need `/bin/bash` which doesn't exists in nixos
  system.activationScripts.binbash = {
    text = ''
      ln -sf /run/current-system/sw/bin/bash /bin/bash
    '';
  };

  # Fix watch errors
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  networking.extraHosts = ''
    127.0.0.1 dev.finishers.com
    127.0.0.1 api.dev.finishers.com
    127.0.0.1 admin.dev.finishers.com
    127.0.0.1 www.dev.finishers.com
    127.0.0.1 metabase.dev.finishers.com
    127.0.0.1 organisateur.dev.finishers.com
    127.0.0.1 club.dev.finishers.com
    127.0.0.1 inngest.dev.finishers.com
  '';

  security.pki.certificateFiles = [./certificates/rootCA.pem];
}
