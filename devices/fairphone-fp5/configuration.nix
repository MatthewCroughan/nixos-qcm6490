{ config, pkgs, ... }:
{
  imports = [
    ./repart.nix
    ../../common/qcm6490.nix
    ../../common/overlays
    ../../common/development.nix
  ];
  networking.hostName = "qcm6490-fairphone-fp5";
  boot.initrd.kernelModules = [
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
  hardware.firmware = [ pkgs.firmware-fairphone-fp5 ];
  hardware.deviceTree = {
    name = "qcom/qcm6490-fairphone-fp5.dtb";
    enable = true;
  };
  environment.variables.ALSA_CONFIG_UCM2 = "${pkgs.alsa-ucm-conf-sc7280}/share/alsa/ucm2";
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 = config.environment.variables.ALSA_CONFIG_UCM2;
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 = config.environment.variables.ALSA_CONFIG_UCM2;
}
