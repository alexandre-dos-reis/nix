# Nix Configuration

## Updating the system

- From the initial nixos directory: `/etc/nixos`: `sudo nixos-rebuild switch .`
- From a flake: `/etc/nixos`: `sudo nixos-rebuild --flake .`
  - As a default, nix looks for the hostname in the `nixosConfigurations` key. You can specify another machine/key with `sudo nixos-rebuild --flake ".#other-config"`

## How-to

### Install Nixos

Todo...

### Install Home-Manager in standalone mode

Usefull is you want to run nix on a (generic linux / darwin) os.

- Copy this repo

`mkdir ~/dev && cd ./dev && git clone git@github.com:alexandre-dos-reis/nix.git nix-config`

- Run home-manager without installing

`nix run github:nix-community/home-manager -- switch --flake ".#{username}@{hostname}"`

- Add the current user to `/etc/nix/nix.conf` or `/etc/nix/nix.custom.conf` if nix installed with determinate system:

`trusted-users = root {username}`

## Todos

- [ ] Split configurations into multiple files to conditionnaly call config per platform/os.
  - For kitty.
- [ ] Try to import the nvim config
  - Using options in lazy.nvim to allow nix managing dependencies introduce some performance downside.
  - [Introducing lazynixhelper use your existing](https://www.reddit.com/r/neovim/comments/18sk8r7/introducing_lazynixhelper_use_your_existing/)

### See if this is usefull

- https://clan.lol/
- https://medium.com/@stylishavocado/managing-docker-containers-in-nixos-fbda0f666dd1

## Resources

- [Official Nix Cookbook](https://nixos.wiki/wiki/Nix_Cookbook)

### Search packages

- [MyNixOs - The best search tool !](https://mynixos.com/)
- [packages](https://search.nixos.org/packages)
- [home-manager](https://mipmip.github.io/home-manager-option-search/)
- [Search through nix versions](https://lazamar.co.uk/nix-versions)

### Docs

- [lib.attrsets](https://ryantm.github.io/nixpkgs/functions/library/attrsets/#sec-functions-library-attrsets)
- [builtins Functions](https://nixos.org/manual/nix/stable/language/builtins.html)
- [Nix Cheat Sheet](https://jdheyburn.co.uk/blog/nix-cheat-sheet/)

#### Darwin / MacOSX

- [nix darwin kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter)
- [Video by Dreams of Autonomy - Nix is my favorite package manager to use on macOS](https://www.youtube.com/watch?v=Z8BL8mdzWHI)

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
- [DevInsideYou - Nix Home Manager Tutorial](https://www.youtube.com/watch?v=utoj6annRK0)
- [Handling Secrets in NixOS: An Overview](https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/)

### Some flakes users

- [fufexan](https://github.com/fufexan/dotfiles/blob/main/home/editors/neovim/default.nix)
- [librephoenix](https://github.com/librephoenix/nixos-config)
- [shaunsingh](https://github.com/shaunsingh/nix-darwin-dotfiles/tree/main)
- [Misterio77](https://github.com/Misterio77/nix-config/tree/main)
- [MatthewCroughan](https://github.com/MatthewCroughan/nixcfg/)
- [jakehamilton](https://github.com/jakehamilton/config)
  - [Is Darwin ?](https://github.com/jakehamilton/config/blob/main/modules/home/user/default.nix#L10)
  - [Gnome extension](https://github.com/jakehamilton/config/blob/main/modules/nixos/desktop/gnome/default.nix)
- [ryan4yin](https://github.com/ryan4yin/nix-config)
  - [nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter)
- [SomeGuyNamedMay](https://github.com/SomeGuyNamedMay/users/blob/master/flake.nix)
- [Home-Manager Flake Template](https://github.com/juspay/nix-dev-home)
- [dustinlyons macos oriented](https://github.com/dustinlyons/nixos-config)
- [Zaney - NixOs wayland, hyprland, nix-colors, ...](https://gitlab.com/Zaney/zaneyos/-/blob/main/flake.nix)
- [Yusef Cross Platform](https://github.com/yusefnapora/nix-config/tree/main)
- [JRMurr xdg example with home-manager](https://github.com/JRMurr/NixOsConfig/blob/main/flake.nix)
- [EmergentMind](https://github.com/EmergentMind/nix-config)
- [pinpox](https://github.com/pinpox/nixos/blob/main/flake.nix)
- [cdata | framework config example](https://github.com/cdata/nixos-config)

### Install home-manager on Ubuntu

- [installing-home-manager-on-ubuntu](https://discourse.nixos.org/t/installing-home-manager-on-ubuntu/25957/8)
- [How to use Nix on Ubuntu or any Linux Distro](https://www.youtube.com/watch?v=5Dd7rQPNDT8&t=1s)
  - [Related article use above](https://tech.aufomm.com/my-nix-journey-use-nix-with-ubuntu/)

### Resources on programs

- [Hyprland as Part of Your Development Workflow](https://haseebmajid.dev/posts/2023-11-15-part-3-hyprland-as-part-of-your-development-workflow/)

### Integrate Neovim with nix

- [nixlalted.com | Best way to work with nix and Lazy](https://nixalted.com/)
- [Setup LazyVim using Nix and home-manager](https://github.com/LazyVim/LazyVim/discussions/1972)
- [Neovim - LazyVim - can’t load plugins](https://discourse.nixos.org/t/neovim-cant-load-plugins/31189/2)
- [](https://github.com/shivajreddy/dotfiles/tree/main/nixos/home/apps/neovim)
- [LongerHV/nixos-configuration](https://github.com/LongerHV/nixos-configuration/tree/02434a93d6719253f087ce67e31ffdeedc45da1e/modules/home-manager/myHome/neovim)

### Making nixGL works with Home Manager

See this [issue](https://github.com/nix-community/nixGL/issues/114).

#### Example:

- [rengare example](https://github.com/rengare/dotfiles/blob/main/nix/helpers.nix)

## Partitioning on Nixos system

From [NixOS Episode 1 - Installation](https://www.youtube.com/watch?v=63sSGuclBn0)

- Create a gpt style partition table
- Create a 500 mb EFI boot partition with FAT swap system
- (Optional) Create a Swap partition based on the ram
- Create the system partition with the remaining space.

## Troubleshooting

### `The SUID sandbox helper binary was found...`

On ubuntu, this error might happen: `The SUID sandbox helper binary was found...`

Workaround for a session: `echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns`

See [SUID sandbox helper breaks packages in Single User Installation](https://github.com/NixOS/nixpkgs/issues/121694#issuecomment-2159420924)

### `command-not-found` unable to open database

See https://discourse.nixos.org/t/command-not-found-unable-to-open-database/3807/8

### Mismatch versions between home-manager and nixpkgs

```
warning: You are using

  Home Manager version 24.05 and
  Nixpkgs version 24.11.

Using mismatched versions is likely to cause errors and unexpected
behavior. It is therefore highly recommended to use a release of Home
Manager that corresponds with your chosen release of Nixpkgs.

If you insist then you can disable this warning by adding

  home.enableNixpkgsReleaseCheck = false;

to your configuration.
```

You need to update the installation of home-manager, [see here](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone).
