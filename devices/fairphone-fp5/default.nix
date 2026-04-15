{ inputs, ... }:
{
  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      packages.qcm6490-fairphone-fp5-uboot-bootimg =
        let
          uboot = pkgs.ubootQCM6490Fairphone5;
        in
        pkgs.runCommand "qcm6490-fairphone-fp5-uboot-bootimg"
          {
            nativeBuildInputs = with pkgs; [
              android-tools
            ];
          }
          ''
            cp ${uboot}/u-boot-nodtb.bin ./u-boot-nodtb.bin
            cp ${uboot}/qcm6490-fairphone-fp5.dtb ./qcm6490-fairphone-fp5.dtb
            cp -r ${inputs.self.nixosConfigurations.qcm6490-fairphone-fp5.config.system.build.kernel} ./kernel
            gzip ./u-boot-nodtb.bin
            mkbootimg \
              --header_version 2 \
              --kernel ./u-boot-nodtb.bin.gz \
              --dtb ./qcm6490-fairphone-fp5.dtb \
              --base "0x00000000" \
              --kernel_offset "0x00008000" \
              --ramdisk_offset "0x01000000" \
              --second_offset "0x00000000" \
              --tags_offset "0x00000100" \
              --pagesize 4096 \
              -o $out
          '';
    };
  flake = {
    nixosConfigurations.qcm6490-fairphone-fp5 = inputs.nixpkgs.lib.nixosSystem {
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
