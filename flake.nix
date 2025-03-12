{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, self, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.fuck = pkgs.runCommand "" { nativeBuildInputs = with pkgs; [
          android-tools
        ]; } ''
          cp -r ${self.nixosConfigurations.qcm6490.config.system.build.kernel} ./kernel
          cat kernel/Image.gz kernel/dtbs/qcom/qcm6490-shift-otter.dtb > Image-with-dtb.gz
          mkbootimg --header_version 2 --kernel Image-with-dtb.gz --ramdisk ${self.nixosConfigurations.qcm6490.config.system.build.initialRamdisk}/initrd --cmdline "console=tty0 console=ttyMSM0,115200n8 root=PARTUUID=30de3e1e-1741-9b4f-8d42-b6a704339254 init=${builtins.unsafeDiscardStringContext (self.nixosConfigurations.qcm6490.config.system.build.toplevel)}/init" --tags_offset 0x00000100 --pagesize 4096 --base 0x00000000 --kernel_offset 0x8000 --dtb_offset "0x01f00000" --dtb ./kernel/dtbs/qcom/qcm6490-shift-otter.dtb -o $out
        '';
        packages.uboot-qcm6490 = pkgs.callPackage ./uboot-qcm6490.nix {};
      };
      flake = {
        nixosConfigurations.qcm6490 = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            "${nixpkgs}/nixos/modules/profiles/minimal.nix"
            ./qcm6490.nix
            ./configuration.nix
#            ./repart.nix
          ];
        };
      };
    };
}
