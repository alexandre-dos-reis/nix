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

  networking.extraHosts = let
    domain = "dev.finishers.com";
    subDomains = ["" "api" "admin" "www" "metabase" "organisateur" "club" "inngest"];
  in
    toString (map (subDomain: "127.0.0.1 ${
        if subDomain == ""
        then domain
        else "${subDomain}.${domain}"
      }\n")
      subDomains);

  security.pki.certificateFiles = [./certificates/rootCA.pem];
}
