{ pkgs, lib, inputs, ... }:
{
#  imports = [ ./unset.nix ];
  hardware.deviceTree.name = "qcom/qcm6490-shift-otter.dtb";
  hardware.deviceTree.enable = true;
#  hardware.deviceTree.overlays = [
#    {
#      name = "disable-venus";
#      dtsText = ''
#        /dts-v1/;
#        /plugin/;
#        / {
#          compatible = "shift,otter";
#          fragment@0 {
#            target = <&venus>;
#            __overlay__ {
#              status = "disabled";
#            };
#          };
#        };
#      '';
#    }
#  ];
  #hardware.enableAllFirmware = true;
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
#    { name = "gpu"; patch = ./gpu.patch; }
{
  name = "drm-panic";
  patch = ./drm-panic.patch;
  structuredExtraConfig = {
    DRM_PANIC = lib.mkForce lib.kernel.yes;
    DRM_PANIC_DEBUG = lib.mkForce lib.kernel.yes;
  };
}
    {
      name = "config-disable-zboot";
      patch = null;
      structuredExtraConfig = {
      #  ACPI_HOTPLUG_CPU = lib.mkForce lib.kernel.unset;
      #  ACPI_HOTPLUG_CPU = lib.mkForce lib.kernel.unset;
        #SND_SOC_SC8280XP = lib.mkForce lib.kernel.no;
        #SND_SOC_X1E80100 = lib.mkForce lib.kernel.no;

        # don't work because of rust toolchain
#        DRM_PANIC = lib.mkForce lib.kernel.no;
#        DRM_PANIC_SCREEN = lib.mkForce lib.kernel.unset;
#        DRM_PANIC_SCREEN_QR_CODE = lib.mkForce lib.kernel.unset;
#

#        QCOM_Q6V5_COMMON = lib.mkForce lib.kernel.module;
#        QCOM_Q6V5_ADSP = lib.mkForce lib.kernel.module;
#        QCOM_RPROC_COMMON = lib.mkForce lib.kernel.module;
#        QCOM_Q6V5_WCSS = lib.mkForce lib.kernel.module;
#        QCOM_SYSMON = lib.mkForce lib.kernel.module;
#        QCOM_WCNSS_PIL = lib.mkForce lib.kernel.module;
#
#        QCOM_Q6V5_MSS = lib.mkForce lib.kernel.module;
#        QCOM_Q6V5_PAS = lib.mkForce lib.kernel.module;


##        DRM_MSM  = lib.mkForce lib.kernel.module;
#        DRM_MSM_DPU  = lib.mkForce lib.kernel.module;
#        USB_OTG = lib.mkForce lib.kernel.yes;
#        DEVMEM = lib.mkForce lib.kernel.yes;
#        IO_STRICT_DEVMEM = lib.mkForce lib.kernel.yes;
#        VIRTIO_MMIO_CMDLINE_DEVICES = lib.mkForce lib.kernel.unset;
#        TOUCHSCREEN_FOCALTECH_FT3658U = lib.mkForce lib.kernel.no;
#        DRM_PANEL_SHIFT_SH8804B = lib.mkForce lib.kernel.module;
#        FSL_ENETC =  lib.kernel.no;
#        FSL_ENETC_CORE =  lib.kernel.unset;
#        IP_NF_TARGET_REDIRECT = lib.mkForce lib.kernel.unset;
#        FSL_ENETC_VF = lib.kernel.no;
#        NXP_ENETC4  = lib.kernel.no;
        #FSL_ENETC_IERB = lib.mkForce lib.kernel.unset;
        #FSL_ENETC_MDIO = lib.mkForce lib.kernel.unset;
        #FSL_ENETC_PTP_CLOCK = lib.mkForce lib.kernel.unset;
        #FSL_ENETC_QOS = lib.mkForce lib.kernel.unset;

#        CRYPTO_AEGIS128_SIMD = lib.mkForce lib.kernel.no;
      #  TOUCHSCREEN_GOODIX_BRL = lib.mkForce lib.kernel.no;
#        TYPEC_MUX_PTN36502 = lib.mkForce lib.kernel.module;
#        DRM_PANEL_RAYDIUM_RM692E5 = lib.mkForce lib.kernel.module;

        SMB_SERVER = lib.mkForce lib.kernel.no;
        #IP_NF_TARGET_REDIRECT = lib.mkForce lib.kernel.unset;
        DRM_NOUVEAU_GSP_DEFAULT = lib.mkForce lib.kernel.unset;
        ZPOOL = lib.mkForce lib.kernel.unset;
        CORESIGHT = lib.mkForce lib.kernel.no;
        HOTPLUG_PCI_PCIE = lib.mkForce lib.kernel.no;
        EFI_ZBOOT = lib.mkForce lib.kernel.yes;
#        DRM_PANEL_SHIFT_SH8804B = lib.mkForce lib.kernel.module;
        KERNEL_ZSTD = lib.mkForce lib.kernel.yes;
        RD_ZSTD = lib.mkForce lib.kernel.yes;
        HID_MULTITOUCH = lib.mkForce lib.kernel.no;
        DRM_XE = lib.mkForce lib.kernel.no;
        EXT3_FS_POSIX_ACL = lib.mkForce lib.kernel.unset;
        EXT3_FS_SECURITY = lib.mkForce lib.kernel.unset;
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
#      baseConfig = "otter_defconfig";
      DTB = true;
#      autoModules = true;
      extraConfig = "";
#      preferBuiltin = true;
      target = "vmlinuz.efi";
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

  systemd.services."pstore-blk" = {
    description = "Load pstore_blk after /dev/sde58 appears";
    wantedBy = [ "sysinit.target" ];
    after = [ "dev-sde58.device" ];
    requires = [ "dev-sde58.device" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe pstore_blk";
      RemainAfterExit = true;
    };
  };

#  boot.kernelModules = [ "pstore_blk" ];
  boot.extraModprobeConfig = ''
    softdep pstore_blk pre: ufshcd-qcom ufshcd_core sd_mod scsi_mod
    options pstore_blk blkdev=/dev/sde58 kmsg_size=64 pmsg_size=64 console_size=64 best_effort=y
  '';

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix {
    src = inputs.linux;
  });

#  boot.loader = {
#    systemd-boot.enable = true;
#  };

#  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix { });
}
