{
  description = "My Nix config";
  # https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/inputs
  inputs = {
    # Nix
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; # We use unstable to get the lastest packages only.
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11"; # Make sure releases of home-manager matches nixpkgs
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
