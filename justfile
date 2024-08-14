# List "Just" commands
default:
  just --list

# Generate github prefetch nix attribute set
nix-prefetech-github user repo:
  nix shell nixpkgs#nix-prefetch-github --command nix-prefetch-github --nix {{user}} {{repo}}

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

# Encrypt secrets with sops
encrypt:
  #!/usr/bin/env sh
  for file in `find secrets -type f`; do 
    if ! grep -q 'sops' "$file"; then
      echo "Encrypting $file"
      sops encrypt --in-place --age $SOPS_AGE_PUBLIC_KEY $file
    else
      echo "$file is already encrypted !"
    fi
  done

# Decrypt secrets with sops
decrypt:
  #!/usr/bin/env sh
  for file in `find secrets -type f`; do 
    if grep -q 'sops' "$file"; then
      echo "Decrypting $file"
      sops decrypt --in-place $file
    else
      echo "$file is already decrypted !"
    fi
  done
