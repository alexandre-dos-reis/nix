{pkgs, ...}: {
  # https://gist.github.com/ArnaudD/8d526b20a03c6c18a3ba
  home.packages = with pkgs; [
    # Utilities
    google-cloud-sdk
    ngrok
    ack
    terraform

    # Geojson
    tippecanoe

    # Certificate
    mkcert
    nssTools
  ];
}
