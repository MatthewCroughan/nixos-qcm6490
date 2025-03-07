{ pkgs, lib, ... }:
{
  hardware.deviceTree.name = "qcom/qcm6490-shift-otter.dtb";
  hardware.deviceTree.enable = true;
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;
  boot.kernelPatches = [
    {
      name = "config-zboot-zstd";
      patch = null;
      extraStructuredConfig = {
        EFI_ZBOOT = lib.mkForce lib.kernel.yes;
        KERNEL_ZSTD = lib.mkForce lib.kernel.yes;
      };
    }
  ];

  nixpkgs.hostPlatform = lib.recursiveUpdate (lib.systems.elaborate "aarch64-linux") {
    linux-kernel.target = "vmlinuz.efi";
    linux-kernel.installTarget = "zinstall";
  };

  boot.loader = {
    systemd-boot.enable = true;
  };

#  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix { });
}
