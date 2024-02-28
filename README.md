# Nixos Configuration

## Updating the system

- From the initial nixos directory: `/etc/nixos`: `sudo nixos-rebuild switch .`
- From a flake: `/etc/nixos`: `sudo nixos-rebuild --flake .`
  - As a default, nix looks for the hostname in the `nixosConfigurations` key. You can specify another machine/key with `sudo nixos-rebuild --flake ".#other-config"`

## Resources

- [Nix Language](https://nixos.org/manual/nix/stable/language/index.html)
- [Nix Flake writing guide](https://nixos-and-flakes.thiscute.world/introduction/)
- [LibrePheonix nixos series](https://www.youtube.com/watch?v=Qull6TMQm4Q&list=PL_WcXIXdDWWpuypAEKzZF2b5PijTluxRG&index=5)
  - [LibrePhoenix nixos config](https://github.com/librephoenix/nixos-config)
- [Nixos flake example Misterio77](https://github.com/Misterio77/nix-config/tree/main)
  - [Nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/main)
- [Nix-darwin-dotfiles flake example](https://github.com/shaunsingh/nix-darwin-dotfiles/tree/main)
