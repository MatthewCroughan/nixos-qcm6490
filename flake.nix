{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, self, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.uboot-qcm6490 = pkgs.callPackage ./uboot-qcm6490.nix {};
      };
      flake = {
        nixosConfigurations.qcm6490 = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            "${nixpkgs}/nixos/modules/profiles/minimal.nix"
            ./qcm6490.nix
            ./configuration.nix
            ./repart.nix
          ];
        };
      };
    };
}
