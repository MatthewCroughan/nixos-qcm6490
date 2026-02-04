{ stdenv, fetchFromGitHub, pil-squasher }:
stdenv.mkDerivation {
  name = "firmware-fairphone-fp5";
  src = fetchFromGitHub {
    owner = "FairBlobs";
    repo = "FP5-firmware";
    rev = "a4908f548e6f88965e78b1478af1751b6a854fc9";
    hash = "sha256-XRklo4XfRrskmIxdyY9duU8nF0svoQV90KwaF15ISjk=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  nativeBuildInputs = [
    pil-squasher
  ];
  installPhase = ''
    mkdir -p $out
    for i in *.mdt; do
      set -x
      pil-squasher "$(basename "$i" .mdt)".mbn "$i"
      set +x
    done
    install -Dm644 a660_zap.mbn -t "$out/lib/firmware/qcom/qcm6490/fairphone5/"
    install -Dm644 adsp.mbn -t \
    	"$out/lib/firmware/qcom/qcm6490/fairphone5/"
    install -Dm644 adsp*.jsn -t \
    	"$out/lib/firmware/qcom/qcm6490/fairphone5/"
    install -Dm644 battmgr.jsn -t \
    	"$out/lib/firmware/qcom/qcm6490/fairphone5/"
    install -Dm644 msbtfw11.mbn -t \
    	"$out/lib/firmware/qca/"
    install -Dm644 msnv11.bin -t \
    	"$out/lib/firmware/qca/"
    install -Dm644 cdsp.mbn -t \
    	"$out/lib/firmware/qcom/qcm6490/fairphone5/"
    install -Dm644 cdsp*.jsn -t \
    	"$out/lib/firmware/qcom/qcm6490/fairphone5/"
    mkdir -p "$out"/usr/share/qcom/qcm6490/Fairphone/
    cp -r hexagonfs/ \
      "$out"/usr/share/qcom/qcm6490/Fairphone/fairphone5
    # Remove files that we don't need - for now
    rm -r "$out"/usr/share/qcom/qcm6490/Fairphone/fairphone5/acdb/
    rm -r "$out"/usr/share/qcom/qcm6490/Fairphone/fairphone5/dsp/
    find "$out/usr/share/qcom/qcm6490/Fairphone/fairphone5/" \
      -type f -exec chmod 0644 {} \;
    install -Dm644 yupik_ipa_fws.mbn \
      "$out/lib/firmware/qcom/qcm6490/fairphone5/ipa_fws.mbn"
    install -Dm644 modem.mbn -t \
      "$out/lib/firmware/qcom/qcm6490/fairphone5/"
    install -Dm644 modem*.jsn -t \
      "$out/lib/firmware/qcom/qcm6490/fairphone5/"
    cp -r modem_pr/ \
      "$out/lib/firmware/qcom/qcm6490/fairphone5/"
    find "$out/lib/firmware/qcom/qcm6490/fairphone5/" \
      -type f -exec chmod 0644 {} \;
    install -Dm644 vpu20_1v.mbn \
      "$out/lib/firmware/qcom/qcm6490/fairphone5/venus.mbn"
    install -Dm644 wpss.mbn -t \
      "$out/lib/firmware/qcom/qcm6490/fairphone5/"
    ls -lah
  '';
}
