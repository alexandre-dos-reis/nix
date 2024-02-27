# Nixos Configuration

## Updating the system

- From the initial nixos directory: `/etc/nixos`: `sudo nixos-rebuild switch .`
- From a flake: `/etc/nixos`: `sudo nixos-rebuild --flake .`
  - As a default, nix looks for the hostname in the `nixosConfigurations` key. You can specify another machine/key with `sudo nixos-rebuild --flake ".#other-config"`

## Resources

- [LibrePheonix nixos series](https://www.youtube.com/watch?v=Qull6TMQm4Q&list=PL_WcXIXdDWWpuypAEKzZF2b5PijTluxRG&index=5)
