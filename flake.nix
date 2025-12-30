{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    #nixpkgs.url = "github:matthewcroughan/nixpkgs/db5aa38d96b5dbd37fbaf18e3d1e3200f0281ed8";
    eden = {
      url = "github:matthewcroughan/eden-flake";
      inputs.nixpkgs.follows = "nixpkgs"; # Do not override if using Cachix
    };
    uboot = {
      url = "github:u-boot/u-boot";
      flake = false;
    };
    linux = {
      url = "github:sc7280-mainline/linux/sc7280-6.18.y";
#      url = "github:matthewcroughan/linux/xreal-attempt-30";
#      url = "git+file:/home/matthew/git/linux";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" ];
      imports = [
        ./common
        ./shift-otter
        ./fairphone-fp5
      ];
    };
}
