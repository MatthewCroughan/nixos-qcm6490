{ buildUBoot, xxd, bison, flex, openssl, gnutls }:
buildUBoot {
  version = "master";
  src = builtins.fetchGit {
    url = "https://github.com/u-boot/u-boot.git";
    rev = "2b1c8d3b2da46ce0f7108f279f04bc66f1d8d09a";
  };
  prePatch = ''
    substituteInPlace configs/qcm6490_defconfig --replace-fail 'qcom/qcs6490-rb3gen2' 'qcom/qcm6490-shift-otter'
  '';
  extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  defconfig = "qcm6490_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  nativeBuildInputs = [ xxd bison flex openssl gnutls ];
#  BL31 = "${BL31}/bl31.bin";
  filesToInstall = ["u-boot*"];
}


