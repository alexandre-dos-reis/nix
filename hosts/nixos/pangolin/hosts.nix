{
  networking.hosts = let
    makeHosts = topDomain: subdomains: ([topDomain] ++ map (subDomain: "${subDomain}.${topDomain}") subdomains);
  in {
    "127.0.0.1" =
      makeHosts "dev.eurorack-3d.com" ["api" "admin" "assets" "minio" "email"]
      ++ makeHosts "everywhere-app.dev" ["api" "admin" "s3" "minio" "emails" "jobs" "db-ui" "storybook"];
  };

  # NOTE: For mkcert generate run:
  # - mkcert -install in ~/.local/share/mkcert
  # It will generate a public and private root certificate authority keys.
  # - import the rootCa here, don't `git add` the rootCA-key.pem file,
  # it's the private key !
  security.pki.certificateFiles = [./certificates/rootCA.pem ./certificates/ea-rootCA.pem];
}
