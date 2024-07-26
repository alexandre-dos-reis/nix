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

  outputs = {
    self,
    ...
  } @ inputs: let
    vars = import ./vars.nix;
    helpers = import ./helpers.nix {
      inherit inputs vars;
      inherit (self) outputs;
    };
    inherit (helpers) mkNixos mkDarwin mkHome mkFormatter;
    inherit (vars) username;
    hosts = (import ./hosts.nix) {inherit inputs;};
    inherit (hosts) white mbp2012 work siliconWork;
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
      "alex@work" = mkHome username work;
      "alex@siliconWork" = mkHome username siliconWork;
    };
  };
}
