{
  description = "My config";

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
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs: let
    mkFlake = import ./helpers.nix inputs;
    inherit (import ./users.nix) alex;
    inherit (import ./hosts.nix inputs) white mbp2012 work siliconWork;
  in
    mkFlake {
      nixos = [white];

      darwin = [mbp2012 siliconWork];

      home = [
        {
          user = alex;
          host = work;
        }
        {
          user = alex;
          host = siliconWork;
        }
      ];
    };
}
