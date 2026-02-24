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
      packages.sony-pdx215 =
        pkgs.runCommand "sony-pdx215"
          {
            nativeBuildInputs = with pkgs; [
              android-tools
            ];
          }
          ''
            cp -r ${inputs.self.nixosConfigurations.qcm6490-fairphone-fp5.config.system.build.kernel} ./kernel
            mkbootimg \
              --header_version 3 \
              --kernel kernel/Image.gz \
              --dtb ./kernel/dtbs/qcom/qcm6490-fairphone-fp5.dtb \
              --base "0x00000000" \
              --kernel_offset "0x00008000" \
              --ramdisk_offset "0x01000000" \
              --second_offset "0x00f00000" \
              --tags_offset "0x00000100" \
              --pagesize 4096 \
              --ramdisk ${inputs.self.nixosConfigurations.qcm6490-fairphone-fp5.config.system.build.initialRamdisk}/initrd \
              -o $out \
              --cmdline "console=tty0 console=ttyMSM0,115200n8 boot.shell_on_fail root=PARTUUID=30de3e1e-1741-9b4f-8d42-b6a704339254 loglevel=8 init=${builtins.unsafeDiscardStringContext (inputs.self.nixosConfigurations.qcm6490-fairphone-fp5.config.system.build.toplevel)}/init"
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
