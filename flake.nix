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
    inherit (helpers) mkNixos mkDarwin mkHome mkFormatter;
    inherit (vars) username;
    inherit (import ./hosts.nix) white mbp2012 work siliconWork;
  in {
    formatter = mkFormatter;

    nixosConfigurations = mkNixos [
      white
    ];

    darwinConfigurations = mkDarwin [
      mbp2012
      siliconWork
    ];

    homeConfigurations = mkHome [
      {
        inherit username;
        host = work;
      }
    ];
  };
}
