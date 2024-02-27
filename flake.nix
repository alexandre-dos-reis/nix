{ 
  description = "Flake for my old white computer";

  inputs = {
      nixpkgs.url = "nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      lib = nixpkgs.lib;
    in 
    {
      nixosConfigurations = {
        # all the computers are list here,
        # usually named by their hostname
        nixos = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./configuration.nix ];
      };
    };
  };
}
