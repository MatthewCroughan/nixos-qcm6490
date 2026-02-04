{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    uboot = {
      url = "github:u-boot/u-boot";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" ];
      imports = [
        ./common
        ./devices
      ];
    };
}
