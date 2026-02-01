{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./otter.nix
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

  networking.useNetworkd = true;
  systemd.services.systemd-networkd-wait-online.restartIfChanged = false;

  services.resolved.enable = true;

  boot.initrd.systemd.emergencyAccess = true;

  hardware.bluetooth.enable = true;

  console.earlySetup = true;

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

  boot.loader.grub.enable = false;

  networking.hostName = "qcm6490-shift-otter";

  hardware.firmware =
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
    [
      #    (pkgs.runCommand "" {} ''
      #      mkdir -p $out/lib/firmware/qcom
      #      cp ${pkgs.linux-firmware}/lib/firmware/qcom/a660_gmu.bin $out/lib/firmware/qcom/a640_gmu.bin
      #    '')
      (pkgs.stdenv.mkDerivation {
        name = "firmware-shift-otter";
        #src = /home/matthew/git/firmware-shift-otter;
        src = pkgs.fetchFromGitHub {
          repo = "firmware-shift-otter";
          owner = "SomeBlobs";
          rev = "28e9784221d11a49f6cebe8df637244a6fc91e30";
          hash = "sha256-4Wc+J/91QER/GjMGZbgogmOvOqGDdBxPDHJUsRyNpd4=";
          #rev = "75058a91d2dd296a5a92b348d767e2c499e551fe";
          #hash = "sha256-AlZ1cHzk5sI8hIHV9Etva7AZyVADbpuZQhXeHZ0aboA=";
        };
        phases = [
          "unpackPhase"
          "installPhase"
        ];
        nativeBuildInputs = [
          pil-squasher
        ];
        installPhase = ''
          sh ./scripts/prepare.sh $src $out
        '';
      })
    ];

  environment.systemPackages =
    with pkgs;
    [
      mdm
    ];
  system.stateVersion = lib.mkDefault config.system.nixos.release;
}
