{ inputs, ... }:
{
  perSystem = {
    config,
    self',
    inputs',
    pkgs,
    system,
    ...
  }:
  {
    packages.uboot = pkgs.ubootQCM6490;
    _module.args.pkgs = import inputs.nixpkgs {
      overlays = [
        inputs.self.overlays.default
      ];
      inherit system;
    };
  };
  flake = {
    overlays.default = (self: super: {
      ubootQCM6490 = super.callPackage ./uboot-qcm6490.nix {
        src = inputs.uboot;
      };
    });
  };
}
