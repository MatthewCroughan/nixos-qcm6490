{ pkgs, lib, ... }:
{
  imports = [ ./unset.nix ];
  hardware.deviceTree.name = "qcom/qcm6490-shift-otter.dtb";
  hardware.deviceTree.enable = true;
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

#  boot.kernelPatches = [
#    {
#      name = "config-zboot-zstd";
#      patch = null;
#      extraStructuredConfig = {
#        EFI_ZBOOT = lib.mkForce lib.kernel.yes;
#        KERNEL_ZSTD = lib.mkForce lib.kernel.yes;
#      };
#    }
#  ];

#  nixpkgs.hostPlatform = lib.recursiveUpdate (lib.systems.elaborate "aarch64-linux") {
#    linux-kernel.target = "vmlinuz.efi";
#    linux-kernel.installTarget = "zinstall";
#  };


  boot.kernelPatches = [
    {
      name = "config-disable-zboot";
      patch = null;
      extraStructuredConfig = {
      #  ACPI_HOTPLUG_CPU = lib.mkForce lib.kernel.unset;
        #SND_SOC_SC8280XP = lib.mkForce lib.kernel.no;
        #SND_SOC_X1E80100 = lib.mkForce lib.kernel.no;

        # don't work because of rust toolchain
        DRM_PANIC = lib.mkForce lib.kernel.no;
        DRM_PANIC_SCREEN = lib.mkForce lib.kernel.unset;
        DRM_PANIC_SCREEN_QR_CODE = lib.mkForce lib.kernel.unset;

        QCOM_Q6V5_COMMON = lib.mkForce lib.kernel.module;
        QCOM_Q6V5_ADSP = lib.mkForce lib.kernel.module;
        QCOM_RPROC_COMMON = lib.mkForce lib.kernel.module;
        QCOM_Q6V5_WCSS = lib.mkForce lib.kernel.module;
        QCOM_SYSMON = lib.mkForce lib.kernel.module;
        QCOM_WCNSS_PIL = lib.mkForce lib.kernel.module;

        QCOM_Q6V5_MSS = lib.mkForce lib.kernel.module;
        QCOM_Q6V5_PAS = lib.mkForce lib.kernel.module;
        DRM_MSM  = lib.mkForce lib.kernel.module;
#        DRM_MSM_DPU  = lib.mkForce lib.kernel.module;
        TOUCHSCREEN_FOCALTECH_FT3658U = lib.mkForce lib.kernel.module;
        DRM_PANEL_SHIFT_SH8804B = lib.mkForce lib.kernel.module;
      #  CRYPTO_AEGIS128_SIMD = lib.mkForce lib.kernel.no;
      #  TOUCHSCREEN_GOODIX_BRL = lib.mkForce lib.kernel.no;
        EFI_ZBOOT = lib.mkForce lib.kernel.no;
        KERNEL_ZSTD = lib.mkForce lib.kernel.unset;
      };
      #extraStructuredConfig = {
      #  TOUCHSCREEN_GOODIX_BERLIN_SPI = lib.mkForce lib.kernel.module;
      #  DRM_PANEL_VISIONOX_RM692E5 = lib.mkForce lib.kernel.module;
      #  SND_SOC_TFA9872 = lib.mkForce lib.kernel.module;
      #  TOUCHSCREEN_FTS = lib.mkForce lib.kernel.module;
      #  VIDEO_IMX471 = lib.mkForce lib.kernel.module;
      #};
    }
  ];

  nixpkgs.hostPlatform = lib.recursiveUpdate (lib.systems.elaborate "aarch64-linux") {
    linux-kernel = {
      name = "aarch64-multiplatform";
      baseConfig = "sc7280_defconfig";
      DTB = true;
      autoModules = true;
      extraConfig = "";
      preferBuiltin = true;
      target = "Image.gz";
      installTarget = "zinstall";
    };
    gcc = {
      arch = "armv8-a";
    };
  };
  #nixpkgs.hostPlatform = lib.recursiveUpdate (lib.systems.elaborate "aarch64-linux") {
  #  linux-kernel.target = "Image.gz";
  #  linux-kernel.installTarget = "zinstall";
  #};

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix { });

#  boot.loader = {
#    systemd-boot.enable = true;
#  };

#  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix { });
}
