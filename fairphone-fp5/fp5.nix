{ lib, ... }:
{
  boot.initrd.kernelModules = lib.mkAfter [
    # Specific to fp5
    # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/blob/master/device/testing/device-fairphone-fp5/modules-initfs
    "fsa4480"
    "goodix_berlin_core"
    "goodix_berlin_spi"
    "msm"
    "panel-raydium-rm692e5"
    "ptn36502"
    "spi-geni-qcom"

    "pmic_glink"
    "qcom_glink_smem"
    "ucsi_glink"
    "snd-soc-aw88261"
#    "snd-soc-sm8250"
#    "snd-soc-sc7280"
  ];
  boot.extraModprobeConfig = ''
    softdep snd-soc-aw88261 pre: snd-soc-sm8250 snd-soc-sc7280
  '';
}
