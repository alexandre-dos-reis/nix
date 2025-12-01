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
    inherit (import ./helpers.nix inputs) mkConfig mkFlake;
    mkEntry = system: options: mkConfig system [(import ./users.nix).alex] options;
  in
    mkFlake {
      mbp2012 = mkEntry "x86_64-darwin";
      kavval-silicon = mkEntry "aarch64-darwin";

      finishers = mkEntry "x86_64-linux";
      pangolin = mkEntry "x86_64-linux";
      raspie = mkEntry "aarch64-linux";

      pop-os = mkEntry "x86_64-linux" {isHomeOnly = true;};
      kavval = mkEntry "x86_64-linux" {isHomeOnly = true;};
    };
}
