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
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    vars = import ./vars.nix;
    helpers = import ./helpers.nix {
      inherit inputs vars;
      inherit (self) outputs;
    };
    inherit (helpers) mkNixos mkDarwin mkHome mkFormatter readJsonFile;
    inherit (vars) username;
    inherit (readJsonFile ./hosts.json) white mbp2012 work siliconWork;
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
      "alex@siliconWork" = mkHome {
        inherit username;
        host = work;
      };
    };
  };
}
