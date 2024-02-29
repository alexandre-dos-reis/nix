# Nixos Configuration

## Updating the system

- From the initial nixos directory: `/etc/nixos`: `sudo nixos-rebuild switch .`
- From a flake: `/etc/nixos`: `sudo nixos-rebuild --flake .`
  - As a default, nix looks for the hostname in the `nixosConfigurations` key. You can specify another machine/key with `sudo nixos-rebuild --flake ".#other-config"`

## Resources

## Search

- [packages](https://search.nixos.org/packages)
- [home-manager](https://mipmip.github.io/home-manager-option-search/)

### Tutorials

- [Nix Language](https://nixos.org/manual/nix/stable/language/index.html)
- [Nix Flake writing guide](https://nixos-and-flakes.thiscute.world/introduction/)
- [LibrePheonix nixos series](https://www.youtube.com/watch?v=Qull6TMQm4Q&list=PL_WcXIXdDWWpuypAEKzZF2b5PijTluxRG&index=5)
- [Nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/main)
- [Manage tmux with Home-Manager](https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/)
- [Ly Yang NixOS series](https://www.youtube.com/watch?v=9fWrxmEYGAs&list=PLLvdqTlFTmuKsiyAI8Q9FgHP4mY0ktPVq)

### Some flake users

- [fufexan](https://github.com/fufexan/dotfiles/blob/main/home/editors/neovim/default.nix)
- [librephoenix](https://github.com/librephoenix/nixos-config)
- [shaunsingh](https://github.com/shaunsingh/nix-darwin-dotfiles/tree/main)
- [Misterio77](https://github.com/Misterio77/nix-config/tree/main)
- [MatthewCroughan](https://github.com/MatthewCroughan/nixcfg/)
- [jakehamilton](https://github.com/jakehamilton/config)
  - [Is Darwin ?](https://github.com/jakehamilton/config/blob/main/modules/home/user/default.nix#L10)
  - [Gnome extension](https://github.com/jakehamilton/config/blob/main/modules/nixos/desktop/gnome/default.nix)
- [nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter)
- [SomeGuyNamedMay](https://github.com/SomeGuyNamedMay/users/blob/master/flake.nix)

### Install home-manager on Ubuntu

- [installing-home-manager-on-ubuntu](https://discourse.nixos.org/t/installing-home-manager-on-ubuntu/25957/8)
- [How to use Nix on Ubuntu or any Linux Distro](https://www.youtube.com/watch?v=5Dd7rQPNDT8&t=1s)
  - [Related article use above](https://tech.aufomm.com/my-nix-journey-use-nix-with-ubuntu/)

## helpers

- Get correct prefetch github values: `nix shell nixpkgs#nix-prefetch-github --command nix-prefetch-github --nix <user> <repo>`
