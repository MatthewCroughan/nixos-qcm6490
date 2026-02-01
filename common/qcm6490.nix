{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  boot.initrd.kernelModules = [
    # IDK
    "pmic_glink_altmode"
    "gpio_sbu_mux"
    "phy-qcom-qmp-combo"
    "gpucc_sc7280"
    #    "dispcc_sc7280"
    "leds-qcom-flash"

    # My stuff
    "ufshcd-core"
    "ufshcd-pltfrm"
    "ufs-qcom"
    "ufs"
    "ufshcd-pci"
    "qcom-iris"

    # Storage Hardware
    "ufs-qcom"
    "ufshcd-core"
    "sd_mod"
    "sr_mod"
    "mmc_block"

    "phy-qcom-snps-femto-v2"
    "phy-qcom-qmp-combo"
    "panel-raydium-rm692e5"
    "ufs-qcom"
    "phy-qcom-qmp-ufs"
    "simpledrm"
    "pmic_glink"
    "pmic_glink_altmode"
    "msm"
    "dispcc-sc7280"
    "fsa4480"
    "ptn36502"
    "libcomposite"
    "usb_f_ncm"
    "icc-osm-l3"
    "gpucc-sc7280"
    "qrtr-smd"
    "spi-geni-qcom"
    "i2c-qcom-geni"
    "qcom-pon"
    "goodix_berlin_spi"
  ];

  boot.kernelParams = [ "loglevel=8" ];

  # We need to generate a vmlinuz.efi, and use zinstall, since this is not the default at the moment
  nixpkgs.hostPlatform = lib.recursiveUpdate (lib.systems.elaborate "aarch64-linux") {
    linux-kernel.target = "vmlinuz.efi";
    linux-kernel.installTarget = "zinstall";
  };

  boot.kernelPatches = [
    # Since we are wanting to use iris, we need to disable venus, and then it
    # just works.. just a hack until all the iris/venus stuff is finished
    # upstream
    {
      name = "use-iris-instead-of-venus";
      #patch = ./patches/sc7280-iris.patch;
      patch = null;
      structuredExtraConfig = {
        VIDEO_QCOM_VENUS = lib.mkForce lib.kernel.no;
      };
    }
    # Disabling some things because they break the kernel build, etc
    {
      name = "disable-some-things";
      patch = null;
      structuredExtraConfig = {
        DRM_NOVA = lib.mkForce lib.kernel.no;
      };
    }
  ];

  #  nixpkgs.hostPlatform = lib.recursiveUpdate (lib.systems.elaborate "aarch64-linux") {
  #    linux-kernel = {
  #      name = "aarch64-multiplatform";
  #      baseConfig = "defconfig";
  #      DTB = true;
  #      extraConfig = "";
  #      target = "vmlinuz.efi";
  #      installTarget = "zinstall";
  #    };
  #    gcc = {
  #      arch = "armv8-a";
  #    };
  #  };

  boot.kernelPackages = pkgs.linuxPackagesFor (
    pkgs.callPackage ./kernel.nix {
      src = inputs.linux;
    }
  );
}
