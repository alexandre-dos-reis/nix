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
    inherit (import ./helpers.nix inputs) mkNixos mkDarwin mkHome mkFormatter;
    inherit (import ./hosts.nix inputs) white mbp2012 work siliconWork;
    inherit (import ./vars.nix) username;
  in {
    formatter = mkFormatter;

    nixosConfigurations = {
      "white" = mkNixos white;
    };

    darwinConfigurations = {
      "mbp2012" = mkDarwin mbp2012;
      "siliconWork" = mkDarwin siliconWork;
    };

    homeConfigurations = {
      "alex@kavval" = mkHome username work;
      "alex@siliconWork" = mkHome username siliconWork;
    };
  };
}
