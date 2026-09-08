{
  networking.hosts = let
    makeHosts = topDomain: subdomains: ([topDomain] ++ map (subDomain: "${subDomain}.${topDomain}") subdomains);
  in {
    "127.0.0.1" =
      makeHosts "dev.eurorack-3d.com" ["api" "admin" "assets" "minio" "email"]
      ++ makeHosts "everywhere-jobs.dev" ["api" "admin" "s3" "s3-console" "files" "emails" "inngest" "db-ui" "storybook" "typesense"];
  };

  # NOTE: For mkcert generate run:
  # - mkcert -install in ~/.local/share/mkcert
  # It will generate a public and private root certificate authority keys.
  # - import the rootCa here, don't `git add` the rootCA-key.pem file,
  # it's the private key !
  security.pki.certificateFiles = [./certificates/rootCA.pem ./certificates/ea-rootCA.pem];

  # Wildcard resolution for *.homelab -> 127.0.0.1 (any subdomain, no need to
  # list them). /etc/hosts can't do wildcards, so dnsmasq handles it.
  # services.dnsmasq = {
  #   enable = true;
  #   # Register dnsmasq as the local resolver so these queries actually go
  #   # through it (updates resolv.conf / systemd-resolved).
  #   resolveLocalQueries = true;
  #   settings.address = [
  #     "/homelab/10.5.0.200" # cluster ip address
  #   ];
  # };
}
