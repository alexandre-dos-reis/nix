{
  description = "My Nix config";
  # https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/inputs
  inputs = {
    # Nix
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; # We use unstable to get the lastest packages only.
    nixpkgs.url = "nixpkgs/nixos-26.05";
    # Make sure releases of home-manager matches nixpkgs
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Grafical utils for home-manager standalone
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fish
    kubectx = {
      # For completions
      url = "github:ahmetb/kubectx";
      flake = false;
    };
    fish-ssh-agent = {
      url = "github:danhper/fish-ssh-agent";
      flake = false;
    };
    # efiInstallAsRemovable = true;
    ssh-agent-macos = {
      url = "github:nifoc/ssh-agent-macos.fish";
      flake = false;
    };

    # Rex
    # Fork branch off upstream ed6915b, carrying the undercurl patch: upstream
    # decodes an underline as a bool, so SGR 4:3 and SGR 58 are both dropped and
    # Neovim's diagnostics underline straight and uncolored. Submitted as
    # zenodea/renux#34; point this back at github:zenodea/renux once it lands.
    # The nixpkgs follows keeps renux off its own pinned unstable, but unstable's
    # GTK 4.24 still breaks it under Hyprland 0.57 (Wayland error 71) — see the
    # overrideAttrs in hosts/nixos/pangolin/configuration.nix, which rebuilds it
    # against stable's GTK. This follows cannot point at "nixpkgs": stable has no
    # zig_0_17. (Its third_party/ghostty submodule is only needed for a plain zig
    # build; the nix package takes ghostty from its own flake input.)
    renux.url = "github:alexandre-dos-reis/renux/undercurl";
    renux.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Editors
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Langs
    zig.url = "github:mitchellh/zig-overlay";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs: let
    inherit (import ./helpers.nix inputs) mkSystems mkHomes;
    users = [(import ./users.nix).alex];
  in {
    nixosConfigurations = mkSystems [
      {
        hostname = "finishers";
        system = "x86_64-linux";
        inherit users;
      }
      {
        hostname = "pangolin";
        system = "x86_64-linux";
        inherit users;
      }
      {
        hostname = "raspie";
        system = "aarch64-linux";
        inherit users;
      }
    ];
    homeConfigurations = mkHomes [
      {
        hostname = "pop-os";
        system = "x86_64-linux";
        inherit users;
      }
      {
        hostname = "kavval";
        system = "x86_64-linux";
        inherit users;
      }
    ];
  };
}
