# Generate github prefetch nix attribute set
nix-prefetech-github user repo:
  nix shell nixpkgs#nix-prefetch-github --command nix-prefetch-github --nix {{user}} {{repo}}

# DARWIN
[macos]
setup-darwin host:
  nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.{{host}}.system

# DARWIN
[macos]
update-darwin host:
  darwin-rebuild switch --flake .#{{host}}

# NIXOS
[linux]
setup-nixos host:
  sudo nixos-rebuild --flake ".#{{host}}"

# NIXOS
[linux]
nix-diff gen1 gen2:
  nix store diff-closures {{gen1}} {{gen2}}

# HOME
# https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes
setup-home-manager host:
  nix run home-manager/master -- init

# HOME
update-home-manager host:
  home-manager switch --flake .#{{host}}

