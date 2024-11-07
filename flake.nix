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
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Editor
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Lang
    zig.url = "github:mitchellh/zig-overlay";

    # Fish
    fish-ssh-agent = {
      url = "github:danhper/fish-ssh-agent";
      flake = false;
    };
    ssh-agent-macos = {
      url = "github:nifoc/ssh-agent-macos.fish";
      flake = false;
    };

    # Fonts
    maple-mono-NF = {
      url = "https://github.com/subframe7536/Maple-font/releases/download/v7.0-beta29/MapleMono-NF.zip";
      flake = false;
    };
  };

  outputs = {nixgl, ...} @ inputs: let
    inherit (import ./helpers.nix inputs) mkFlake;

    alex = {
      username = "alex";
      email = "ajm.dosreis.daponte@gmail.com";
      fullname = "Alexandre Dos Reis";
      font = "Maple Mono NF"; # This is not the nix package name but rather the name installed on the system
      editor = "nvim";
      colors = {
        background = "#072329";
        cursor = "#708183";
      };
      # This allows to install npm packages globally with: `npm i -g <some-package>`
      npm.packages.path = "~/.npm-packages";
    };
  in
    mkFlake [
      {
        hostname = "white";
        arch = "x84_64";
        os = "linux";
        users = [alex];
      }
      {
        hostname = "mbp2012";
        arch = "x84_64";
        os = "darwin";
        users = [alex];
      }
      {
        hostname = "kavval";
        arch = "x86_64";
        os = "linux";
        overlays = [nixgl.overlay];
        isNixGlWrapped = true;
        xdgDataFileEnabled = true;
        isManagedByHomeManager = true;
        users = [alex];
      }
      {
        hostname = "kavval-silicon";
        arch = "aarch64";
        os = "darwin";
        users = [alex];
      }
      {
        hostname = "raspie";
        arch = "aarch64";
        os = "linux";
        users = [alex];
      }
    ];
}
