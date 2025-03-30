# https://docs.u-boot.org/en/latest/board/qualcomm/board.html
{ buildUBoot, xxd, bison, flex, openssl, gnutls, fetchgit, python3Packages, android-tools }:
let
  qtestsign = fetchgit {
    url = "https://git.codelinaro.org/linaro/qcomlt/u-boot.git";
    rev = "9f5031424714694721c00c04aa068c3ffc6e7f14";
    hash = "sha256-scG5Q5WVYlX8rS5TnInkYmXSgO2977qR9zipP1Q0rIY=";
  };
  python = python3Packages.python.withPackages (p: [ p.cryptography ]);
in
buildUBoot {
  version = "master";
  src = builtins.fetchGit {
    url = "https://github.com/u-boot/u-boot.git";
    rev = "2b1c8d3b2da46ce0f7108f279f04bc66f1d8d09a";
    allRefs = true;
  };
  prePatch = ''
    substituteInPlace configs/qcm6490_defconfig --replace-fail 'qcom/qcs6490-rb3gen2' 'qcom/qcm6490-shift-otter'
    ln -s ${qtestsign}/qtestsign.py $(pwd)/qtestsign.py
  '';
  extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  defconfig = "qcm6490_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  nativeBuildInputs = [ xxd bison flex openssl gnutls python android-tools ];
#  BL31 = "${BL31}/bl31.bin";
  filesToInstall = ["u-boot*"];
  preInstall = ''
    #${python}/bin/python ${qtestsign}/qtestsign.py -v6 aboot -o $out/u-boot.mbn $out/u-boot.elf
    ls -lah
  '';
}


