{
  buildLinux,
  fetchFromGitHub,
  ...
}:
buildLinux rec {
  modDirVersion = "6.18.7";
  version = modDirVersion;
  src = fetchFromGitHub {
    owner = "sc7280-mainline";
    repo = "linux";
    rev = "v${modDirVersion}-sc7280";
    hash = "sha256-N2aBczTg3agYd7DpwFaiXZ3yY3Zn+sIW3qu8LmEFrJ8=";
  };
  extraMeta = {
    platforms = [ "aarch64-linux" ];
    hydraPlatforms = [ "" ];
  };
}
