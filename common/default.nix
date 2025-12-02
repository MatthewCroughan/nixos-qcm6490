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
      ubootQCM6490ShiftOtter = super.callPackage ./uboot-qcm6490.nix {
        src = inputs.uboot;
        extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
        filesToInstall = ["u-boot*" "dts/upstream/src/arm64/qcom/qcm6490-shift-otter.dtb" ];
      };
      ubootQCM6490Fairphone5 = super.callPackage ./uboot-qcm6490.nix {
        src = inputs.uboot;
        extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-fairphone-fp5" ];
        filesToInstall = ["u-boot*" "dts/upstream/src/arm64/qcom/qcm6490-fairphone-fp5.dtb" ];
      };
    });
  };
}
