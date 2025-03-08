{ lib
, buildLinux
, fetchFromGitLab
, fetchFromGitHub
, ... } @ args:
let
  src = fetchFromGitLab {
    owner = "sdm845-mainline";
    repo = "linux";
    rev = "otter-bringup";
    hash = "";
  };
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
  version = "${modDirVersion}";
  extraMeta = {
    platforms = [ "aarch64-linux" ];
    hydraPlatforms = [ "" ];
  };
} // (args.argsOverride or { }))).overrideAttrs (old: {
})


