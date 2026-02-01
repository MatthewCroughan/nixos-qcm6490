{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
let
  firmware-fairphone-fp5 =
    let
      pil-squasher-src = pkgs.fetchFromGitHub {
        repo = "pil-squasher";
        owner = "linux-msm";
        rev = "3c9f8b8756ba6e4dbf9958570fd4c9aea7a70cf4";
        hash = "sha256-MEW85w3RQhY3tPaWtH7OO22VKZrjwYUWBWnF3IF4YC0=";
      };
      pil-squasher = pkgs.writeCBin "pil-squasher" (
        builtins.readFile "${pil-squasher-src}/pil-squasher.c"
      );
    in
    (pkgs.stdenv.mkDerivation {
      name = "firmware-fairphone-fp5";
      src = pkgs.fetchFromGitHub {
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
    });
in
{
  imports = [
    ./fp5.nix
    ./device-tree.nix
    ./repart.nix
    ../../common/qcm6490.nix
    ../../common/development.nix
    ../../common/overlays
    ../../common/wireless.nix
  ];

  fileSystems."/".device = "/dev/disk/by-partlabel/userdata";
  fileSystems."/".fsType = "ext4";

  system.build.rootfsImage = pkgs.callPackage "${pkgs.path}/nixos/lib/make-ext4-fs.nix" {
    storePaths = [
      config.system.build.toplevel
      config.boot.kernelPackages.kernel
    ];
    compressImage = false;
    volumeLabel = "nixos";
  };

  networking.hostName = "qcm6490-fairphone-fp5";

  # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/blob/master/device/testing/firmware-fairphone-fp5/APKBUILD#L27-29
  hardware.firmware = [ firmware-fairphone-fp5 ];
  environment.variables.FP5_FIRMWARE = firmware-fairphone-fp5;

  environment.systemPackages =
    with pkgs;
    [
      mdm
    ];
  system.stateVersion = lib.mkDefault config.system.nixos.release;
}
