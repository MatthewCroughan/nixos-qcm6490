{ pkgs, ... }:
let
  mdm = pkgs.callPackage ./mdm.nix {};
in
{
  boot.initrd.supportedFilesystems = { vfat = true; };
  boot.postBootCommands = ''
    echo Extracting Qualcomm firmware hackily...
    set -x
    mkdir -p /tmp/.fwsetup
    mkdir -p /lib/firmware/qcom/qcm6490/SHIFT/otter
    ${mdm}/bin/make-dynpart-mappings /dev/sda9 /dev/sda9
    mount -t ext4 -o ro /dev/mapper/vendor_a /tmp/.fwsetup
    cp -r /tmp/.fwsetup/firmware/* /lib/firmware/qcom/qcm6490/SHIFT/otter
    for i in $(ls /tmp/.fwsetup/firmware/*.mdt); do cp $i /lib/firmware/qcom/qcm6490/SHIFT/otter/$(echo $(basename $i) | cut -f 1 -d '.').mbn; done
    umount /tmp/.fwsetup
    mount /dev/sde4 /tmp/.fwsetup
    cp -r /tmp/.fwsetup/image/* /lib/firmware/qcom/qcm6490/SHIFT/otter
    for i in $(ls /tmp/.fwsetup/image/*.mdt); do cp $i /lib/firmware/qcom/qcm6490/SHIFT/otter/$(echo $(basename $i) | cut -f 1 -d '.').mbn; done
    set +x
  '';
}
