{ buildUBoot, xxd, bison, flex, openssl, gnutls, fetchFromGitHub, python3Packages }:
let
  qtestsign = fetchFromGitHub {
    owner = "msm8916-mainline";
    repo = "qtestsign";
    rev = "ce6ba20f4ead008e5b522a81179c98dd48ccf06e";
    hash = "sha256-f4IhfEbv88ui7el2JgpfamdFNJKkTX5EjtA4N2PEEQo=";
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
  '';
  extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
  defconfig = "qcm6490_defconfig";
  extraMeta.platforms = ["aarch64-linux"];
  nativeBuildInputs = [ xxd bison flex openssl gnutls ];
#  BL31 = "${BL31}/bl31.bin";
  filesToInstall = ["u-boot.elf"];
  postInstall = ''
    ${python}/bin/python ${qtestsign}/qtestsign.py -v6 aboot -o $out/u-boot.mbn $out/u-boot.elf
  '';
}


