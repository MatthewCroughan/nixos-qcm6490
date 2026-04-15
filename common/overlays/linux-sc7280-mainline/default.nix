{
  buildLinux,
  fetchFromGitHub,
  ...
}:
buildLinux rec {
  modDirVersion = "7.0.0";
  version = modDirVersion;
  src = fetchFromGitHub {
    owner = "sc7280-mainline";
    repo = "linux";
    rev = "v${modDirVersion}-sc7280";
    hash = "sha256-aFFmGhblTEKukORSJ7jw4dkcQsPJAo6xiDFWka4uHr0=";
  };
  extraMeta = {
    platforms = [ "aarch64-linux" ];
  };
}
