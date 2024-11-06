{
  description = "My Nix config";

  inputs = {
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
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    zig.url = "github:mitchellh/zig-overlay";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = {nixgl, ...} @ inputs: let
    inherit (import ./helpers.nix inputs) mkFlake mkHost;
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
        host = mkHost {
          hostname = "white";
          path = "white";
          arch = "x84_64";
          os = "linux";
        };
        users = [alex];
      }
      {
        host = mkHost {
          hostname = "mbp2012";
          path = "mbp2012";
          arch = "x84_64";
          os = "darwin";
        };
        users = [alex];
      }
      {
        host = mkHost {
          hostname = "kavval";
          path = "work";
          arch = "x84_64";
          os = "linux";
          overlays = [nixgl.overlay];
          isNixGlWrapped = true;
          xdgDataFileEnabled = true;
          isManagedByHomeManager = true;
        };
        users = [alex];
      }
      {
        host = mkHost {
          hostname = "kavval-silicon";
          path = "siliconWork";
          arch = "aarch64";
          os = "darwin";
        };
        users = [alex];
      }
      {
        host = mkHost {
          hostname = "raspie";
          path = "raspie";
          arch = "aarch64";
          os = "linux";
        };
        users = [alex];
      }
    ];
}
