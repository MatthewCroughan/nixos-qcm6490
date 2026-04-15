{
  android-tools,
  ubootQCM6490ShiftOtter,
  runCommand,
  gzip,
}:
runCommand "qcm6490-shift-otter-uboot-bootimg"
  {
    nativeBuildInputs = [
      android-tools
      gzip
    ];
  }
  ''
    cp ${ubootQCM6490ShiftOtter}/u-boot-nodtb.bin ./u-boot-nodtb.bin
    cp ${ubootQCM6490ShiftOtter}/qcm6490-shift-otter.dtb ./qcm6490-shift-otter.dtb
    gzip -c ./u-boot-nodtb.bin > ./u-boot-nodtb.bin.gz
    mkbootimg \
      --header_version 2 \
      --kernel ./u-boot-nodtb.bin.gz \
      --dtb ./qcm6490-shift-otter.dtb \
      --base 0x00000000 \
      --kernel_offset 0x00008000 \
      --ramdisk_offset 0x01000000 \
      --second_offset 0x00000000 \
      --tags_offset 0x00000100 \
      --pagesize 4096 \
      -o $out
  ''
