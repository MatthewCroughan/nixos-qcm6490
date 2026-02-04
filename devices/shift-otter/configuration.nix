{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./otter.nix
    ./repart.nix
    ../../common/qcm6490.nix
    ../../common/overlays
    ../../common/development.nix
  ];
}
