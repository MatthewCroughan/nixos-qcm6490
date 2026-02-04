{ stdenv, fetchFromGitHub, pil-squasher }:
stdenv.mkDerivation {
  name = "firmware-shift-otter";
  src = fetchFromGitHub {
    repo = "firmware-shift-otter";
    owner = "SomeBlobs";
    rev = "28e9784221d11a49f6cebe8df637244a6fc91e30";
    hash = "sha256-4Wc+J/91QER/GjMGZbgogmOvOqGDdBxPDHJUsRyNpd4=";
  };
  phases = [
    "unpackPhase"
    "installPhase"
  ];
  nativeBuildInputs = [
    pil-squasher
  ];
  installPhase = ''
    sh ./scripts/prepare.sh $src $out
  '';
}
