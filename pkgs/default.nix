{
  lib,
  pkgs,
  linuxPackagesFor,
}:
lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    # stevia = callPackage ./stevia.nix {};
    firmware-shift-otter = callPackage ./firmware-shift-otter { };
    firmware-fairphone-fp5 = callPackage ./firmware-fairphone-fp5 { };
    linuxPackages_sc7280-mainline = linuxPackagesFor (callPackage ./linux-sc7280-mainline { });
    pil-squasher = callPackage ./pil-squasher { };
  }
)
