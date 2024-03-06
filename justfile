# https://github.com/casey/just
[linux]
run:
  @echo "This will only run on linux"

[macos]
run:
  @echo "This will only run on macos"

foo := if "2" == "2" { "Good!" } else { "1984" }

bar:
  @echo "{{foo}}"

# Generate github prefetch nix attribute set
nix-prefetech-github user repo:
  nix shell nixpkgs#nix-prefetch-github --command nix-prefetch-github --nix {{user}} {{repo}}

[macos]
setup-darwin host:
  nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.{{host}}.system

[macos]
update-darwin host:
  nix-darwin switch --flake .#{{host}}

# https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes
setup-home-manager host:
  nix run home-manager/master -- init

# https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes
update-home-manager host:
  home-manager switch --flake ".#{{host}}"

setup-nixos host:
  sudo nixos-rebuild --flake ".#{{host}}"

nix-diff gen1 gen2:
  nix store diff-closures {{gen1}} {{gen2}}
