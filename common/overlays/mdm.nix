{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-linux,
  toybox,
  coreutils-full,
  lvm2,
  libmd,
}:

stdenv.mkDerivation rec {
  pname = "make-dynpart-mappings";
  version = "10.2.4";

  src = fetchFromGitLab {
    owner = "flamingradian";
    repo = "make-dynpart-mappings";
    rev = version;
    hash = "sha256-N2H8bsGi/3aiIB1nL7WkNqWF2/X5NS6+uaeUkDmaZAg=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv make-dynpart-mappings $out/bin/make-dynpart-mappings
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    util-linux
    lvm2
    libmd
  ];

  meta = {
    description = "A command-line tool that uses the device mapper to make block devices based on dynamic partitions";
    homepage = "https://gitlab.com/flamingradian/make-dynpart-mappings/-/tree/master?ref_type=heads";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "make-dynpart-mappings";
    platforms = lib.platforms.all;
  };
}
