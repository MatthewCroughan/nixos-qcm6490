{ alsa-ucm-conf, fetchFromGitHub }:

alsa-ucm-conf.overrideAttrs (oldAttrs: {
  version = "20260403";
  patches = [];
  src = fetchFromGitHub {
    owner = "sc7280-mainline";
    repo = "alsa-ucm-conf";
    rev = "c6fdb24805b75b47a0dc415ba199563b20fad42d";
    hash = "sha256-zsCRqgrzq3V+ICPrpMEthGhJecpGKoM6MD0hZmZqS6Q=";
  };
})
