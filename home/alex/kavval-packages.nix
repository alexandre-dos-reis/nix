{pkgs, ...}: {
  # https://gist.github.com/ArnaudD/8d526b20a03c6c18a3ba
  home.packages = with pkgs; [
    # docker
    # docker
    # docker-buildx
    # docker-compose
    # containerd

    # Utilities
    google-cloud-sdk
    ngrok
    ack
    terraform

    # Poeditor
    # (ruby_3_3.withPackages (ps: with ps; [
    # pry
    # ]))

    # Certificate
    mkcert
    nssTools

    # NodeJS
    nodejs_18
    corepack_18
    # These will be installed globally
    nodePackages.nodemon
    nodePackages.prettier
    nodePackages.vercel
  ];
}
