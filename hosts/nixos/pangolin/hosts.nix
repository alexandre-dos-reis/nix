{
  networking.extraHosts = let
    domain = "dev.eurorack-3d.com";
    subDomains = ["" "api" "admin" "assets" "minio"];
  in
    toString (map (subDomain: "127.0.0.1 ${
        if subDomain == ""
        then domain
        else "${subDomain}.${domain}"
      }\n")
      subDomains);

  security.pki.certificateFiles = [./certificates/rootCA.pem];
}
