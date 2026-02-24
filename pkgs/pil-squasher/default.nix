{ stdenv, fetchFromGitHub, buildPackages }:
stdenv.mkDerivation {
  name = "pil-squasher";
  src = fetchFromGitHub {
    repo = "pil-squasher";
    owner = "linux-msm";
    rev = "3c9f8b8756ba6e4dbf9958570fd4c9aea7a70cf4";
    hash = "sha256-MEW85w3RQhY3tPaWtH7OO22VKZrjwYUWBWnF3IF4YC0=";
  };
  nativeBuildInputs = [ buildPackages.gcc ];
  buildPhase = ''
    gcc -o pil-squasher pil-squasher.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp pil-squasher $out/bin/
  '';
}
