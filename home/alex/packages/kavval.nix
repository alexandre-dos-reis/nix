{ pkgs, ... }:

{
  home.packages = with pkgs; [ 
    google-cloud-sdk
    nodejs_18
    ruby
    docker
    docker-compose
  ];
}
