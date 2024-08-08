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
    inherit (hosts) white work mbp2012 siliconWork raspie;
    inherit (users) alex;
  in
    mkFlake [
      {
        host = white;
        users = [alex];
      }
      {
        host = mbp2012;
        users = [alex];
      }
      {
        host = work;
        users = [alex];
      }
      {
        host = siliconWork;
        users = [alex];
      }
      {
        host = raspie;
        users = [alex];
      }
    ];
}
