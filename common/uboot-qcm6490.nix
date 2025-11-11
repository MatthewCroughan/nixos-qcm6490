# https://docs.u-boot.org/en/latest/board/qualcomm/board.html
{ buildUBoot, xxd, bison, flex, openssl, gnutls, android-tools, ... }@args:
buildUBoot {
  src = args.src;
  version = "master";
  patches = [
    ./cd-gpio.patch # Required for making the SD Card work on shift-otter
#    ./gpio-luca.patch # Makes the volume up button work in u-boot/systemd-boot
  ];
  extraConfig = ''
    CONFIG_CMD_HASH=y
    CONFIG_CMD_UFETCH=y
    CONFIG_CMD_SELECT_FONT=y
    CONFIG_VIDEO_FONT_8X16=y
  '';
  prePatch = ''
#    cat configs/qcom_defconfig board/qualcomm/qcom-phone.config > f
#    mv f configs/qcom_defconfig
#    cat configs/qcm6490_defconfig board/qualcomm/qcom-phone.config > f
#    mv f configs/qcm6490_defconfig
    # For making SD Card discovery not time out in u-boot on shift-otter
    substituteInPlace drivers/mmc/sdhci.c --replace-fail 'udelay(10)' 'udelay(100)'
  '';
  extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  defconfig = "qcom_defconfig qcom-phone.config";
  #defconfig = "qcm6490_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  nativeBuildInputs = [ xxd bison flex openssl gnutls android-tools ];
  filesToInstall = ["u-boot*" "dts/upstream/src/arm64/qcom/qcm6490-shift-otter.dtb" ];
  #preInstall = ''
  #  #${python}/bin/python ${qtestsign}/qtestsign.py -v6 aboot -o $out/u-boot.mbn $out/u-boot.elf
  #'';
}


