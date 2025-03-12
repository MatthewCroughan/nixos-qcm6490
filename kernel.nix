{ lib
, buildLinux
, fetchFromGitLab
, fetchFromGitHub
, ... } @ args:
let
  src = fetchFromGitHub {
    owner = "amartinz";
    repo = "sc7280-mainline_linux";
    rev = "2a3775318eb42e97c970b6e41d1f290f0a76542a";
    hash = "sha256-QsJVqam1gOT9EDiHodPxCgy0Uu1rjcHPnhmO0far1mY=";
  };

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
in (buildLinux (args // {
  inherit src;
  modDirVersion = "${modDirVersion}";
  enableCommonConfig = false;
#  defconfig = "sc7280_defconfig";
  autoModules = false;
  version = "${modDirVersion}";
  extraMeta = {
    platforms = [ "aarch64-linux" ];
    hydraPlatforms = [ "" ];
  };
} // (args.argsOverride or { }))).overrideAttrs (old: {
  prePatch = ''
    patchShebangs lib/tests/module/gen_test_kallsyms.sh
  '';
  NIX_CFLAGS_COMPILE = "-Wno-error=return-type";
})
