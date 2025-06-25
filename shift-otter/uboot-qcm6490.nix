# https://docs.u-boot.org/en/latest/board/qualcomm/board.html
{ buildUBoot, xxd, bison, flex, openssl, gnutls, fetchgit, python3Packages, android-tools, fetchpatch2 }:
let
  qtestsign = fetchgit {
    url = "https://github.com/msm8916-mainline/qtestsign.git";
    rev = "ce6ba20f4ead008e5b522a81179c98dd48ccf06e";
    hash = "sha256-f4IhfEbv88ui7el2JgpfamdFNJKkTX5EjtA4N2PEEQo=";
  };
  python = python3Packages.python.withPackages (p: [ p.cryptography ]);
in
buildUBoot {
  version = "master";
  #src = /home/matthew/git/u-boot;
  src = builtins.fetchGit {
    #url = "https://git.codelinaro.org/linaro/qcomlt/u-boot.git";
    #rev = "8295989d91f1a3297f1de3f9be50a1b44618bbe3";
    url = "https://github.com/u-boot/u-boot.git";
    rev = "2ab10ed2399b0c1c790733884935c94ad65aa2a8";
#    allRefs = true;
  };
  patches = [
    ./cd-gpio.patch
  ];
  extraConfig = ''
    CONFIG_CMD_HASH=y
    CONFIG_CMD_UFETCH=y
    CONFIG_CMD_SELECT_FONT=y
    CONFIG_VIDEO_FONT_8X16=y
  '';
  prePatch = ''
    cat configs/qcom_defconfig board/qualcomm/qcom-phone.config > f
    mv f configs/qcom_defconfig
    cat configs/qcm6490_defconfig board/qualcomm/qcom-phone.config > f
    mv f configs/qcm6490_defconfig
    #cp ${./temp.dts} dts/upstream/src/arm64/qcom/qcm6490-shift-otter.dts
    #echo "CONFIG_MIPI_DPHY_HELPERS=y" >> configs/qcom_defconfig
    #echo "QCOM_UFS_FORCE_LOW_POWER_MODE=y" >> configs/qcm6490_defconfig
    #echo "CMD_UFETCH=y" >> configs/qcom_defconfig
    #echo "CLK_QCOM_SXR2250=y" >> configs/qcm6490_defconfig
    #echo "CONFIG_UFS_AMD_VERSAL2=y" >> configs/qcom_defconfig
    #substituteInPlace configs/qcm6490_defconfig --replace-fail 'qcom/qcs6490-rb3gen2' 'qcom/qcm6490-shift-otter'
    #substituteInPlace drivers/clk/qcom/clock-sc7280.c --replace-fail 'GATE_CLK(GCC_SDCC2_APPS_CLK, 0x14004, BIT(0)),' 'GATE_CLK(GCC_SDCC2_APPS_CLK, 0x14004, BIT(0)),
    #GATE_CLK(GCC_UFS_PHY_ICE_CORE_CLK, 0x77064, BIT(0)),'

    #substituteInPlace arch/arm/mach-snapdragon/board.c --replace-fail 'addr_alloc(SZ_128M)' 'addr_alloc(SZ_256M)'
    substituteInPlace drivers/mmc/sdhci.c --replace-fail 'udelay(10)' 'udelay(100)'
    #substituteInPlace arch/arm/Kconfig --replace-fail 'select SYSRESET_PSCI if CONFIG_PSCI_RESET' 'select SYSRESET_PSCI'
    #substituteInPlace drivers/ufs/ufs.c --replace-fail 'wmb();' 'udelay(1000);'
    ln -s ${qtestsign}/qtestsign.py $(pwd)/qtestsign.py
  '';
  extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  #defconfig = "qcom_defconfig";
  defconfig = "qcm6490_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  nativeBuildInputs = [ xxd bison flex openssl gnutls python android-tools ];
#  BL31 = "${BL31}/bl31.bin";
  filesToInstall = ["u-boot*" "dts/upstream/src/arm64/qcom/qcm6490-shift-otter.dtb" ];
  #preInstall = ''
  #  #${python}/bin/python ${qtestsign}/qtestsign.py -v6 aboot -o $out/u-boot.mbn $out/u-boot.elf
  #'';
}


