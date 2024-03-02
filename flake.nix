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
    pkgs = nixpkgs.legacyPackages;
    helpers = import ./helpers.nix {
      inherit inputs vars;
      inherit (self) outputs;
    };
    inherit (helpers) mkNixos mkDarwin mkHome mkFormatter;

    vars = import ./vars.nix pkgs;
    inherit (vars) username;
    inherit (vars.hosts) white mbp2012 work;
  in {
    formatter = mkFormatter;

    nixosConfigurations = {
      white = mkNixos ./hosts/nixos/${white};
    };

    darwinConfigurations = {
      mbp2012 = mkDarwin ./hosts/darwin/${mbp2012};
    };

    homeConfigurations = {
      "${username}@${work}" = mkHome ./home/${username} pkgs.x86_64-linux;
    };
  };
}
