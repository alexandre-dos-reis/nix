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

    # Terminals
    ghostty.url = "github:ghostty-org/ghostty";

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
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Langs
    zig.url = "github:mitchellh/zig-overlay";

    # Cli
    encore = {
      url = "github:encoredev/encore-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs: let
    inherit (import ./users.nix) alex;
  in
    (import ./helpers.nix inputs) [
      {
        hostname = "white";
        system = "x86_64-linux";
        users = [alex];
      }
      {
        hostname = "mbp2012";
        system = "x86_64-darwin";
        users = [alex];
      }
      {
        hostname = "finishers";
        system = "x86_64-linux";
        users = [(alex // {modules = ["hyprland"];})];
      }
      {
        hostname = "kavval";
        system = "x86_64-linux";
        isManagedByHomeManager = true;
        users = [alex];
      }
      {
        hostname = "pop-os";
        system = "x86_64-linux";
        isManagedByHomeManager = true;
        users = [alex];
      }
      {
        hostname = "pangolin";
        system = "x86_64-linux";
        users = [(alex // {modules = ["hyprland"];})];
      }
      {
        hostname = "kavval-silicon";
        system = "aarch64-darwin";
        users = [alex];
      }
      {
        hostname = "raspie";
        system = "aarch64-linux";
        users = [alex];
      }
    ];
}
