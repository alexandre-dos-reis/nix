{
  networking.extraHosts = let
    domain = "dev.eurorack-3d.com";
  in
    toString (map (subDomain: "127.0.0.1 ${
        if subDomain == ""
        then domain
        else "${subDomain}.${domain}"
      }\n")
      ["" "api" "admin" "assets" "minio" "email"]);

  # NOTE: For mkcert generate run:
  # - mkcert -install in ~/.local/share/mkcert
  # It will generate a public and private root certificate authority keys.
  # - import the rootCa here, don't `git add` the rootCA-key.pem file,
  # it's the private key !
  security.pki.certificateFiles = [./certificates/rootCA.pem];
}
