{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:matthewcroughan/nixpkgs/50c82bd44855c7d970cccfac3ce720af1c4d6691";
    eden = {
      url = "github:matthewcroughan/eden-flake";
      inputs.nixpkgs.follows = "nixpkgs"; # Do not override if using Cachix
    };
    uboot = {
      url = "github:u-boot/u-boot";
      flake = false;
    };
    linux = {
#      url = "github:sc7280-mainline/linux/sc7280-6.18-wip";
      url = "github:matthewcroughan/linux/xreal-attempt-29";
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
