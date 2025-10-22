{ lib
, buildLinux
, linuxManualConfig
, fetchFromGitLab
, fetchFromGitHub
, ... } @ args:
let
  src = builtins.fetchTree "github:sc7280-mainline/linux?rev=5ac4ccb053f66b928fefd8b5d8243009555ce41b";

#  src = fetchFromGitHub {
#    owner = "sc7280-mainline";
#    repo = "linux";
#    rev = "e1b1fc29f55ba3942b4cef783cffb39fea4bb814";
#    hash = "sha256-dWyQkjwdWK5wtG5JC+1vjNh0ieh+i/+KNasDROz7Tsg=";
#  };

#  src = fetchFromGitLab {
#    owner = "sdm845-mainline";
#    repo = "linux";
#    rev = "otter-bringup";
#    hash = "sha256-Woe5u8KSFxZ+ROFhvFnZPYG1sVBpoo6vEshhpD+d/Js=";
#  };
  kernelVersion = rec {
    # Fully constructed string, example: "5.10.0-rc5".
    string = "${version + "." + patchlevel + "." + sublevel + (lib.optionalString (extraversion != "") extraversion)}";
    file = "${src}/Makefile";
    version = toString (builtins.match ".+VERSION = ([0-9]+).+" (builtins.readFile file));
    patchlevel = toString (builtins.match ".+PATCHLEVEL = ([0-9]+).+" (builtins.readFile file));
    sublevel = toString (builtins.match ".+SUBLEVEL = ([0-9]+).+" (builtins.readFile file));
    # rc, next, etc.
    extraversion = toString (builtins.match ".+EXTRAVERSION = ([a-z0-9-]+).+" (builtins.readFile file));
  };
  modDirVersion = "${kernelVersion.string}";
in (linuxManualConfig ({
  inherit src;
  modDirVersion = "${modDirVersion}";
  configfile = ./kernel-config;
  version = "${modDirVersion}";
  extraMeta = {
    platforms = [ "aarch64-linux" ];
    hydraPlatforms = [ "" ];
  };
} // (args.argsOverride or { }))).overrideAttrs (old: {
  postUnpack = ''
    patchShebangs lib/tests/module/gen_test_kallsyms.sh
#    cat arch/arm64/configs/defconfig arch/arm64/configs/otter_defconfig | uniq > defconfig
#    mv defconfig arch/arm64/configs/otter_defconfig
  '';
  NIX_CFLAGS_COMPILE = "-Wno-error=return-type -Wno-error=implicit-function-declaration";
})
