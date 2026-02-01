# https://docs.u-boot.org/en/latest/board/qualcomm/board.html
{
  buildUBoot,
  xxd,
  bison,
  flex,
  openssl,
  gnutls,
  android-tools,
  fetchpatch,
  ...
}@args:
buildUBoot {
  src = args.src;
  version = "master";
  patches = [
    ./cd-gpio.patch # Required for making the SD Card work on shift-otter
  ];
  extraConfig = ''
    CONFIG_CMD_HASH=y
    CONFIG_CMD_BLKMAP=y
    CONFIG_BLKMAP=y
    CONFIG_CMD_UFETCH=y
    CONFIG_CMD_SELECT_FONT=y
    CONFIG_VIDEO_FONT_8X16=y
  '';
  prePatch = ''
    # For making SD Card discovery not time out in u-boot on shift-otter
    substituteInPlace drivers/mmc/sdhci.c --replace-fail 'udelay(10)' 'udelay(100)'
  '';
  inherit (args) filesToInstall extraMakeFlags;
  #  extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  defconfig = "qcom_defconfig qcom-phone.config";
  extraMeta.platforms = [ "aarch64-linux" ];
  nativeBuildInputs = [
    xxd
    bison
    flex
    openssl
    gnutls
    android-tools
  ];
}
