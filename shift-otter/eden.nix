{ inputs, ... }:
{
  imports = [
    inputs.eden.nixosModules.default
  ];
  programs.eden = {
    enable = true;
    enableCache = true; # Optional: Enable cache (see Cachix section)
  };
}
