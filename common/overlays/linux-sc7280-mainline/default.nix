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
    hash = "sha256-FwcAzJulaX6+w8yaWUCYhba7guO/459AEEvoDfY2pZ0=";
  };
  extraMeta = {
    platforms = [ "aarch64-linux" ];
    hydraPlatforms = [ "" ];
  };
}
