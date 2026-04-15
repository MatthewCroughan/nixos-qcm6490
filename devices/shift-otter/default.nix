{ inputs, ... }:
{
  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      packages.qcm6490-shift-otter-uboot-bootimg = pkgs.callPackage ./uboot-bootimg.nix {};
      packages.uboot-qcm6490-shift-otter = pkgs.callPackage ./uboot-qcm6490.nix { };
    };
  flake = {
    nixosConfigurations.qcm6490-shift-otter = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
