{
  inputs = {
#    nixpkgs.url = "github:nixos/nixpkgs/9833723db2cdca89cbf96e7106ce75a6fbdbb3e7";
    nixpkgs.url = "github:nixos/nixpkgs/staging-next";
    linux = {
#      url = "github:matthewcroughan/linux/gpu";
      url = "git+file:/home/matthew/git/linux";
#      url = "github:sc7280-mainline/linux/sc7280-6.16.y";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" ];
      imports = [
        ./shift-otter
        ./fairphone-fp5
      ];
    };
}
