{pkgs, ...}: {
  # https://gist.github.com/ArnaudD/8d526b20a03c6c18a3ba
  home.packages = with pkgs; [
    google-cloud-sdk
    ruby
    docker
    docker-compose
    google-chrome
    ngrok

    # NodeJS
    nodejs_18
    corepack_18
    nodePackages.nodemon
    nodePackages.prettier
  ];
}
