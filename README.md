# Nix Configuration

## Updating the system

- From the initial nixos directory: `/etc/nixos`: `sudo nixos-rebuild switch .`
- From a flake: `/etc/nixos`: `sudo nixos-rebuild --flake .`
  - As a default, nix looks for the hostname in the `nixosConfigurations` key. You can specify another machine/key with `sudo nixos-rebuild --flake ".#other-config"`

## Resources

- [Nix Colors Input]](https://github.com/Misterio77/nix-colors)

### Search packages

- [packages](https://search.nixos.org/packages)
- [home-manager](https://mipmip.github.io/home-manager-option-search/)

### Tutorials & Articles

- [Nix Language](https://nixos.org/manual/nix/stable/language/index.html)
- [Nix Flake writing guide](https://nixos-and-flakes.thiscute.world/introduction/)
- [LibrePheonix nixos series](https://www.youtube.com/watch?v=Qull6TMQm4Q&list=PL_WcXIXdDWWpuypAEKzZF2b5PijTluxRG&index=5)
- [Nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/main)
- [Manage tmux with Home-Manager](https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/)
- [Ly Yang NixOS series](https://www.youtube.com/watch?v=9fWrxmEYGAs&list=PLLvdqTlFTmuKsiyAI8Q9FgHP4mY0ktPVq)
- [Declarative GNOME configuration with NixOS](https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/)
- [Walkthrough of Nix Install and Setup on MacOS](https://www.youtube.com/watch?v=LE5JR4JcvMg&t=1662s)
- [Tidying up your $HOME with Nix](https://juliu.is/tidying-your-home-with-nix/)

### Some flakes users

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
- [Home-Manager Flake Template](https://github.com/juspay/nix-dev-home)
- [dustinlyons macos oriented](https://github.com/dustinlyons/nixos-config)
- [Zaney - NixOs wayland, hyprland, nix-colors, ...](https://gitlab.com/Zaney/zaneyos/-/blob/main/flake.nix)
- [Yusef Cross Platform](https://github.com/yusefnapora/nix-config/tree/main)
- [JRMurr xdg example with home-manager](https://github.com/JRMurr/NixOsConfig/blob/main/flake.nix)

### Install home-manager on Ubuntu

- [installing-home-manager-on-ubuntu](https://discourse.nixos.org/t/installing-home-manager-on-ubuntu/25957/8)
- [How to use Nix on Ubuntu or any Linux Distro](https://www.youtube.com/watch?v=5Dd7rQPNDT8&t=1s)
  - [Related article use above](https://tech.aufomm.com/my-nix-journey-use-nix-with-ubuntu/)
