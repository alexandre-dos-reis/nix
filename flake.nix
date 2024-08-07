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
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs: let
    inherit (import ./helpers.nix inputs) mkFlake hosts users;
    inherit (hosts) white work mbp2012 siliconWork;
    inherit (users) alex;
  in
    mkFlake {
      nixos = [white];

      darwin = [mbp2012 siliconWork];

      home = [
        {
          host = work;
          users = [alex];
        }
        {
          host = siliconWork;
          users = [alex];
        }
      ];
    };
}
