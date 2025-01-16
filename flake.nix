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

    # Terminals
    ghostty.url = "github:ghostty-org/ghostty";

    # Nushell

    nu-scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
    };

    # Fish
    kubectx = {
      url = "github:ahmetb/kubectx";
      flake = false;
    };
    fish-ssh-agent = {
      url = "github:danhper/fish-ssh-agent";
      flake = false;
    };
    ssh-agent-macos = {
      url = "github:nifoc/ssh-agent-macos.fish";
      flake = false;
    };

    # Editors
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Langs
    zig.url = "github:mitchellh/zig-overlay";

    # qmk = {
    #   url = "https://github.com/qmk/qmk_firmware.git";
    #   type = "git";
    #   flake = false;
    #   submodules = true;
    # };
  };

  outputs = inputs: let
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
        hostname = "kavval";
        system = "x86_64-linux";
        isManagedByHomeManager = true;
        users = [alex];
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
