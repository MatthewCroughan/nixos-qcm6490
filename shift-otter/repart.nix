{ modulesPath, pkgs, config, lib, ... }:
let
  efiArch = pkgs.stdenv.hostPlatform.efiArch;
          "edk2-uefi-shell.conf" = ''
          '';
in
{
  imports = [ "${modulesPath}/image/repart.nix" ];
  boot.loader.grub.enable = false;

  # Probably necessary for root resize
  systemd.repart.enable = true;
  systemd.repart.partitions."03-root".Type = "root";
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.root = "gpt-auto";
  boot.initrd.supportedFilesystems.ext4 = true;

  fileSystems."/".device = lib.mkForce "/dev/disk/by-label/nixos";
  fileSystems."/".fsType = lib.mkForce "ext4";
  fileSystems."/boot".device = lib.mkForce "/dev/disk/by-label/ESP";
  fileSystems."/boot".fsType = lib.mkForce "vfat";
  image.repart = {
    name = "image";
    partitions = {
      "10-uboot-padding" = {
        repartConfig = {
          Type = "linux-generic";
          Label = "uboot-padding";
          SizeMinBytes = "10M";
        };
      };
      "20-esp" = {
        contents = {
          "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
          "/EFI/Linux/${config.system.boot.loader.ukiFile}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
          "/loader/loader.conf".source = pkgs.writeText "loader.conf" ''
            timeout 5
            console-mode keep
          '';
          "/loader/entries/shell.conf".source = pkgs.writeText "shell.conf" ''
            title  EDK2 UEFI Shell
            efi    /EFI/EDK2-UEFI-SHELL/SHELL.EFI
          '';
        };
        repartConfig = {
          Type = "esp";
          Format = "vfat";
          Label = "ESP";
          SizeMinBytes = "500M";
          GrowFileSystem = true;
        };
      };
      "30-root" = {
        storePaths = [ config.system.build.toplevel ];
        contents."/boot".source = pkgs.runCommand "boot" { } "mkdir $out";
        repartConfig = {
          Type = "root";
          Format = "ext4";
          Label = "nixos";
          Minimize = "guess";
          GrowFileSystem = true;
        };
      };
    };
  };
}
