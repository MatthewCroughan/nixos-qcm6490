{ config, lib, ... }:
{
  system.stateVersion = lib.mkDefault config.system.nixos.release;
  fileSystems."/".device = "/dev/disk/by-partlabel/userdata";
  fileSystems."/".fsType = "ext4";
}
