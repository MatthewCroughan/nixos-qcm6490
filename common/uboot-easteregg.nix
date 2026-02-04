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
  # https://social.treehouse.systems/@danct12/115333742888454752
  patches = [
    #    ./gpio-luca.patch # Makes the volume up button work in u-boot/systemd-boot
    ./cd-gpio.patch # Required for making the SD Card work on shift-otter
    (fetchpatch {
      url = "https://github.com/Danct12/u-boot/commit/777ef8e6ac06e9a7c98c65213d2b69df3e4e795a.patch";
      sha256 = "0jf6c9qrxzm5yb90a85b5b52bk0z6y435xvar7ihj8n1s68w3j9h";
    })
    (fetchpatch {
      url = "https://github.com/Danct12/u-boot/commit/247c326f27782ea3734bc5d2a4fc7c857524c9dc.patch";
      sha256 = "10z02l2k1dnkrh6bzda224b56dqs1h7xz7hxksl8164j9vkbnhjd";
    })
    (fetchpatch {
      url = "https://github.com/Danct12/u-boot/commit/0965fa1b450a03fecc2cc898190f395e82fb3b6b.patch";
      sha256 = "07z52n27aykcjjkpjbq1s3iabkg9g25snwbzs3axpjv13nkyya3z";
    })
    (fetchpatch {
      url = "https://github.com/Danct12/u-boot/commit/0b027fbce5af7fc65aac35f40555967356c86ebb.patch";
      sha256 = "01xlpp0i27xy5lmjggckz4y4q320kdd0a9gv6gm7sy0q89rdjnsi";
    })
    (fetchpatch {
      url = "https://github.com/Danct12/u-boot/commit/084c96e4d6f35540cac358f259a02d63586bf3e9.patch";
      sha256 = "0xp6ijaqa3darz22lgpvav79fc3bka4vjla5h97iy72wrlwccbvi";
    })
    (fetchpatch {
      url = "https://github.com/Danct12/u-boot/commit/659094af0561343f0d39885ca899045beaa5760d.patch";
      sha256 = "0bym72aapvcrwgrplcrmx1yfp4hnqi7m9cb0wqryk1nwxmkln9jk";
    })
#    ./compat.patch
  ];
  extraConfig = ''
    CONFIG_CMD_HASH=y
    CONFIG_CMD_BLKMAP=y
    CONFIG_BLKMAP=y
    CONFIG_CMD_UFETCH=y
    CONFIG_CMD_SELECT_FONT=y

    CONFIG_VIDEO_FONT_8X16=n
    CONFIG_VIDEO_FONT_16X32=y
    CONFIG_VIDEO_FONT_16X32_VGA=y
    CONFIG_BMP_24BPP=y
    CONFIG_AWARDMODULAR_START_16X32=y
    CONFIG_AWARDMODULAR=y
  '';
  prePatch = ''
    #    cat configs/qcom_defconfig board/qualcomm/qcom-phone.config > f
    #    mv f configs/qcom_defconfig
    #    cat configs/qcm6490_defconfig board/qualcomm/qcom-phone.config > f
    #    mv f configs/qcm6490_defconfig
        # For making SD Card discovery not time out in u-boot on shift-otter
        substituteInPlace drivers/mmc/sdhci.c --replace-fail 'udelay(10)' 'udelay(100)'
  '';
  inherit (args) filesToInstall extraMakeFlags;
  # extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  defconfig = "qcom_defconfig qcom-phone.config";
  #defconfig = "qcm6490_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  nativeBuildInputs = [
    xxd
    bison
    flex
    openssl
    gnutls
    android-tools
  ];
  #  filesToInstall = ["u-boot*" "dts/upstream/src/arm64/qcom/qcm6490-shift-otter.dtb" ];
  #preInstall = ''
  #  #${python}/bin/python ${qtestsign}/qtestsign.py -v6 aboot -o $out/u-boot.mbn $out/u-boot.elf
  #'';
}

