# List "Just" commands
default:
  just --list

# Generate github prefetch nix attribute set
nix-prefetech-github user repo:
  nix shell nixpkgs#nix-prefetch-github --command nix-prefetch-github --nix {{user}} {{repo}}


nix-prefetech-url url:
  nix shell nixpkgs#nix-prefetch-git --command nix-prefetch-url {{url}}

# Setup nix darwin
[macos]
setup-darwin host:
  nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.{{host}}.system

# Setup nix os
[linux]
setup-nixos host:
  sudo nixos-rebuild --flake ".#{{host}}"

# https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes
# Setup Home Manager
setup-home-manager:
  nix run home-manager/master -- init

# Compare generations
[linux]
diff gen1 gen2:
  nix store diff-closures {{gen1}} {{gen2}}

# Delete generations older than 7d
clean:
  nix-collect-garbage --delete-older-than 7d
