{
  system.activationScripts = {
    stdio = {
      # Run after /dev has been mounted
      deps = [ "specialfs" ];
      text =
        ''
          make-dynpart-mappings /dev/sda9 /dev/sda9
          mkdir /mnt
          mount -t ext4 -o ro /dev/mapper/vendor_a /mnt
          mount -o remount,rw /nix/store
          mkdir -p "$(readlink /run/current-system/firmware)/qcom/qcm6490/SHIFT/otter"
          cp -r /mnt/firmware/* "$(readlink /run/current-system/firmware)/qcom/qcm6490/SHIFT/otter"
          for i in $(ls /mnt/firmware/*.mdt); do cp $i "$(readlink /run/current-system/firmware)/qcom/qcm6490/SHIFT/otter"/$(echo $(basename $i) | cut -f 1 -d '.').mbn; done
          umount /mnt
          mount /dev/sde4 /mnt
          cp -r /mnt/image/* "$(readlink /run/current-system/firmware)/qcom/qcm6490/SHIFT/otter"
          for i in $(ls /mnt/image/*.mdt); do cp $i "$(readlink /run/current-system/firmware)/qcom/qcm6490/SHIFT/otter"/$(echo $(basename $i) | cut -f 1 -d '.').mbn; done
        '';
      };
    };
}
