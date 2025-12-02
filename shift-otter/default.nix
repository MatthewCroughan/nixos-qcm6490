{ inputs, ... }: {
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    packages.qcm6490-shift-otter-uboot-bootimg = let
      uboot = pkgs.ubootQCM6490ShiftOtter;
    in pkgs.runCommand "qcm6490-shift-otter-uboot-bootimg" { nativeBuildInputs = with pkgs; [
      android-tools
    ]; } ''
      cp ${uboot}/u-boot-nodtb.bin ./u-boot-nodtb.bin
      cp ${uboot}/qcm6490-shift-otter.dtb ./qcm6490-shift-otter.dtb
      cp -r ${inputs.self.nixosConfigurations.qcm6490-shift-otter.config.system.build.kernel} ./kernel
      gzip ./u-boot-nodtb.bin
      mkbootimg \
        --header_version 2 \
        --kernel ./u-boot-nodtb.bin.gz \
        --dtb ./qcm6490-shift-otter.dtb \
        --base "0x00000000" \
        --kernel_offset "0x00008000" \
        --ramdisk_offset "0x01000000" \
        --second_offset "0x00000000" \
        --tags_offset "0x00000100" \
        --pagesize 4096 \
        -o $out
    '';
    packages.qcm6490-shift-otter-linux-bootimg = pkgs.runCommand "qcm6490-shift-otter-linux-bootimg" { nativeBuildInputs = with pkgs; [
      android-tools
    ]; } ''
      cp -r ${inputs.self.nixosConfigurations.qcm6490-shift-otter.config.system.build.kernel} ./kernel
      mkbootimg \
        --header_version 2 \
        --kernel kernel/Image.gz \
        --dtb ./kernel/dtbs/qcom/qcm6490-shift-otter.dtb \
        --base "0x00000000" \
        --kernel_offset "0x00008000" \
        --ramdisk_offset "0x01000000" \
        --second_offset "0x00000000" \
        --tags_offset "0x00000100" \
        --pagesize 4096 \
        --ramdisk ${inputs.self.nixosConfigurations.qcm6490-shift-otter.config.system.build.initialRamdisk}/initrd \
        -o $out \
        --cmdline "console=tty0 console=ttyMSM0,115200n8 boot.shell_on_fail root=PARTUUID=30de3e1e-1741-9b4f-8d42-b6a704339254 loglevel=8 init=${builtins.unsafeDiscardStringContext (inputs.self.nixosConfigurations.qcm6490-shift-otter.config.system.build.toplevel)}/init"
    '';
    packages.uboot-qcm6490-shift-otter = pkgs.callPackage ./uboot-qcm6490.nix {
      extraMakeFlags = [ "DEVICE_TREE=qcom/qcm6490-shift-otter" ];
      filesToInstall = ["u-boot*" "dts/upstream/src/arm64/qcom/qcm6490-shift-otter.dtb" ];
    };
  };
  flake = {
    nixosConfigurations.qcm6490-shift-otter = inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
