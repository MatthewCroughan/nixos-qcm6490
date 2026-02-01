{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  #  imports = [ ./unset.nix ];

  # These need to load latest, hence mkAfter
  boot.initrd.kernelModules = lib.mkAfter [
    # Specific to shift otter
    # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/blob/master/device/testing/device-shift-otter/modules-initfs
    "focaltech_ts"
    "fsa4480"
    "gpi"
    "msm"
    "panel-shift-sh8804b"
    "pmic_glink"
    "qcom_glink_smem"
    "ucsi_glink"
  ];

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
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

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

  #  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix {
  #    src = inputs.linux;
  #  });

  #  boot.loader = {
  #    systemd-boot.enable = true;
  #  };

  #  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix { });
}
