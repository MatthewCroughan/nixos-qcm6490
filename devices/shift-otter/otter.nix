{
  pkgs,
  ...
}:
{
  hardware.firmware = [ pkgs.firmware-shift-otter ];
  boot.initrd.kernelModules = [
    # IDK
    "pmic_glink_altmode"
    "gpio_sbu_mux"
    "phy-qcom-qmp-combo"
    "gpucc_sc7280"
    "dispcc_sc7280"
    "leds-qcom-flash"

    # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/blob/master/device/testing/device-shift-otter/modules-initfs
    "focaltech_ts"
    "fsa4480"
    "gpi"
    "msm"
    "panel-shift-sh8804b"
    "pmic_glink"
    "qcom_glink_smem"
    "ucsi_glink"

    # My stuff
    "ufs-qcom"
    "ufshcd-core"
    "qcom-iris"
  ];
  networking.hostName = "qcm6490-shift-otter";
  hardware.deviceTree = {
    name = "qcom/qcm6490-shift-otter.dtb";
    enable = true;
  };
}
