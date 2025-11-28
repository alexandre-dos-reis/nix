{
  description = "My Nix config";

  # https://nixos-and-flakes.thiscute.world/other-usage-of-flakes/inputs
  inputs = {
    # Nix
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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
    # nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
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
    darwinConfigurations = mkSystems [
      {
        hostname = "mbp2012";
        system = "x86_64-darwin";
        inherit users;
      }
      {
        hostname = "kavval-silicon";
        system = "aarch64-darwin";
        inherit users;
      }
    ];
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
