# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Applying changes

**NixOS hosts** (finishers, pangolin, raspie):
```bash
sudo nixos-rebuild switch --flake ".#<hostname>"
# or with nh (preferred, configured in home/alex/programs/nh.nix):
nh os switch
```

**Home-manager standalone** (pop-os, kavval — non-NixOS Linux):
```bash
home-manager switch --flake ".#alex@<hostname>"
# or:
nh home switch
```

**Flake update:**
```bash
nix flake update
```

**Garbage collection:**
```bash
just clean        # deletes generations older than 7 days
# nh auto-cleans, keeping last 10 generations (see nh.nix)
```

**Prefetch a GitHub input:**
```bash
just nix-prefetech-github <user> <repo>
```

## Architecture

### Entry point: `flake.nix`

Defines two output types built via helpers in `helpers.nix`:

- `nixosConfigurations` — full NixOS systems, built with `mkSystems`
- `homeConfigurations` — home-manager standalone for non-NixOS hosts, built with `mkHomes`

Both helpers wire up the flake inputs, inject `pkgs-unstable`, and resolve the correct module path based on hostname and OS.

### Host configs: `hosts/nixos/<hostname>/`

Each host has a `default.nix` (entry, just imports `configuration.nix`) and a `configuration.nix` that sets NixOS options (bootloader, networking, display manager, system packages, users). Shared NixOS modules live in `hosts/nixos/common/` (keyboard, docker, hyprland, printers).

### Home config: `home/alex/`

`home.nix` — shared base imported by all platforms. Imports:
- `programs/` — per-program home-manager configs (fish, git, tmux, neovim, vscode, etc.)
- `packages.nix` — `home.packages` list
- `files/` — raw file/script installations
- `scripts/` — custom nix-built scripts

`linux/default.nix` — Linux-specific entry; conditionally imports `hyprland/` unless `useNixGL = true` (i.e., non-NixOS hosts skip Hyprland since it requires NixOS).

`darwin/default.nix` — macOS entry point.

### Two nixpkgs channels

- `pkgs` → `nixpkgs` (stable, currently 25.11) — used for most packages
- `pkgs-unstable` → `nixpkgs-unstable` — injected as `extraSpecialArgs`; use it for packages that need a newer version than stable provides

### `useNixGL` flag

Injected into home-manager modules. `true` on standalone (non-NixOS) hosts. When true, nixGL wrappers are applied for OpenGL apps, and the Hyprland home config is skipped (it requires NixOS-level Hyprland).

### Colors / theming

`home/alex/colors/` — palette defined in `base.json`/`palette.json`, with a `script.js` to regenerate derived values. Referenced in Hyprland and waybar configs.

## Key files

| File | Purpose |
|---|---|
| `flake.nix` | All inputs and output declarations |
| `helpers.nix` | `mkSystems` / `mkHomes` builders |
| `users.nix` | User definitions (username, description) |
| `home/alex/constants.nix` | Shared constants (editor, colors, fonts) |
| `home/alex/programs/nh.nix` | `nh` configured with flake path `~/dev/nix-config` |
| `hosts/nixos/common/` | Shared NixOS modules across hosts |

## Package search resources

- https://mynixos.com/ — packages + home-manager options
- https://search.nixos.org/packages — NixOS packages
- https://mipmip.github.io/home-manager-option-search/ — home-manager options
- https://lazamar.co.uk/nix-versions — find which nixpkgs revision has a specific package version
