{ lib, pkgs, config, ... }:
{
  fileSystems."/".device = "/dev/disk/by-partlabel/userdata";
  fileSystems."/".fsType = "ext4";

  system.build.rootfsImage = pkgs.callPackage "${pkgs.path}/nixos/lib/make-ext4-fs.nix" {
    storePaths = [ config.system.build.toplevel config.boot.kernelPackages.kernel ];
    compressImage = false;
    volumeLabel = "nixos";
  };

  networking.wireless = {
    enable = true;
    networks = {
      DoESLiverpool.pskRaw = "63e49f779a41eda7be1510a275a07e519d407af706d0f2d3cc3140b9aecd412f";
    };
  };

  hardware.firmwareCompression = "none";

  hardware.bluetooth.enable = true;

#  boot.initrd.compressor = "zstd";

  console.earlySetup = true;

  boot.kernelParams = [ "boot.shell_on_fail" ];

  boot.initrd.availableKernelModules = lib.mkForce [
    "fsa4480"
    "msm"
    "panel-shift-sh8804b"
    "qcom_glink_smem"
    "pmic_glink"
    "ucsi_glink"
    "gpi"
    "focaltech_ts"
    "ext2"
    "ext4"
#    "ahci"
#    "sata_nv"
#    "sata_via"
#    "sata_sis"
#    "sata_uli"
#    "ata_piix"
#    "pata_marvell"
#    "nvme"
#    "sd_mod"
#    "sr_mod"
    "mmc_block"
#    "uhci_hcd"
#    "ehci_hcd"
#    "ehci_pci"
#    "ohci_hcd"
#    "ohci_pci"
#    "xhci_hcd"
#    "xhci_pci"
    "usbhid"
    "hid_generic"
  ];

#  boot.initrd.kernelModules = lib.mkForce [
#    "focaltech_ts"
#    "fsa4480"
#    "gpi"
#    "msm"
#    "panel-shift-sh8804b"
#    "pmic_glink"
#    "qcom_glink_smem"
#    "ucsi_glink"
#  ];

  boot.loader.grub.enable = false;

  nixpkgs.config.allowUnfree = true;
  networking.firewall.enable = false;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 90;
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkForce "no";
    };
    openFirewall = lib.mkForce true;
  };
  nix = {
    settings = {
      trusted-users = [ "@wheel" "root" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  users.mutableUsers = false;
  users.users.root.password = "default";
  users.users.matthew = {
    password = "default";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOJDRQfb1+7VK5tOe8W40iryfBWYRO6Uf1r2viDjmsJtAAAABHNzaDo= backup-yubikey"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDgsWq+G/tcr6eUQYT7+sJeBtRmOMabgFiIgIV44XNc6AAAABHNzaDo= main-yubikey"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJMi3TAuwDtIeO4MsORlBZ31HzaV5bji1fFBPcC9/tWuAAAABHNzaDo= nano-yubikey"
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  networking.hostName = "qcm6490";

  services.avahi = {
    openFirewall = true;
    nssmdns4 = true;
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  hardware.enableAllFirmware = lib.mkForce true;

#  hardware.firmware = let
#    pil-squasher-src = pkgs.fetchFromGitHub {
#      repo = "pil-squasher";
#      owner = "linux-msm";
#      rev = "3c9f8b8756ba6e4dbf9958570fd4c9aea7a70cf4";
#      hash = "sha256-MEW85w3RQhY3tPaWtH7OO22VKZrjwYUWBWnF3IF4YC0=";
#    };
#    pil-squasher = pkgs.writeCBin "pil-squasher" (builtins.readFile "${pil-squasher-src}/pil-squasher.c");
#  in [
#    (pkgs.stdenv.mkDerivation {
#      name = "firmware-shift-otter";
#      src = pkgs.fetchFromGitHub {
#        repo = "firmware-shift-otter";
#        owner = "SomeBlobs";
#        rev = "a983951ce4da4059349b34d6d27a0303dcce1f4d";
#        hash = "sha256-XQkfr+ittyFBS+tb2nMz6THdkTTgLPR+bUUA/c70YyM=";
#        #rev = "75058a91d2dd296a5a92b348d767e2c499e551fe";
#        #hash = "sha256-AlZ1cHzk5sI8hIHV9Etva7AZyVADbpuZQhXeHZ0aboA=";
#      };
#      phases = [ "unpackPhase" "installPhase" ];
#      nativeBuildInputs = [
#        pil-squasher
#      ];
#      installPhase = ''
#        sh ./scripts/prepare.sh $src $out
#      '';
#    })
#  ];

  environment.systemPackages = let
    mdm = pkgs.callPackage ./mdm.nix {};
  in with pkgs; [
    mdm
    vim
    git
#    kitty
    btop
    sway
  ];
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    dejavu_fonts
  ];
  security.sudo.extraRules = [{
    users = [ "matthew" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
  system.stateVersion = "24.11";
}
