{ config, pkgs, ... }:
{
  hardware.deviceTree = {
    name = "qcom/qcm6490-fairphone-fp5.dtb";
    enable = true;
    #kernelPackage = config.boot.kernelPackages.kernel.overrideAttrs {
    #  name = "hardware-device-tree";
    #  outputs = [ "out" ];
    #  configurePhase = ''
    #    DTS=arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
    #    cp ${./qcm6490-shift-otter.dts} "arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts"
    #    mkdir -p "$out/dtbs/qcom"
    #    $CC -E -nostdinc -Iinclude -undef -D__DTS__ -x assembler-with-cpp "$DTS" | \
    #      ${pkgs.dtc}/bin/dtc -I dts -O dtb -@ -o $out/dtbs/qcom/qcm6490-shift-otter.dtb
    #    exit 0
    #  '';
    #};
  };
}
