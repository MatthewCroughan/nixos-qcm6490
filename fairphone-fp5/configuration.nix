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

  hardware.bluetooth.enable = true;

#  boot.initrd.compressor = "zstd";

  console.earlySetup = true;

  boot.initrd.systemd.tpm2.enable = false;

  boot.kernelParams = [ "boot.shell_on_fail" ];

  boot.initrd.availableKernelModules = lib.mkForce [
    "ext2"
    "ext4"
#    "autofs"
    "efivarfs"
    "sd_mod"
#    "sr_mod"

"fsa4480"
"goodix_berlin_core"
"goodix_berlin_spi"
"msm"
"panel-raydium-rm692e5"
"ptn36502"
"spi-geni-qcom"

    "mmc_block"
    "usbhid"
    #"hid_generic"
    #"hid_lenovo"
    #"hid_apple"
    #"hid_roccat"
    #"hid_logitech_hidpp"
    #"hid_logitech_dj"
    #"hid_microsoft"
    #"hid_cherry"
    #"hid_corsair"
  ];

#  boot.initrd.availableKernelModules = lib.mkForce [
#    "fsa4480"
#    "msm"
#    "qcom_glink_smem"
#    "pmic_glink"
#    "ucsi_glink"
#    "gpi"
##    "focaltech_ts"
#    "ext2"
#    "ext4"
##    "ahci"
##    "sata_nv"
##    "sata_via"
##    "sata_sis"
##    "sata_uli"
##    "ata_piix"
##    "pata_marvell"
##    "nvme"
##    "sd_mod"
##    "sr_mod"
#    "mmc_block"
##    "uhci_hcd"
##    "ehci_hcd"
##    "ehci_pci"
##    "ohci_hcd"
##    "ohci_pci"
##    "xhci_hcd"
##    "xhci_pci"
#    "usbhid"
#    "hid_generic"
#  ];

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

  # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/blob/master/device/testing/firmware-fairphone-fp5/APKBUILD#L27-29
  hardware.firmware = let
    pil-squasher-src = pkgs.fetchFromGitHub {
      repo = "pil-squasher";
      owner = "linux-msm";
      rev = "3c9f8b8756ba6e4dbf9958570fd4c9aea7a70cf4";
      hash = "sha256-MEW85w3RQhY3tPaWtH7OO22VKZrjwYUWBWnF3IF4YC0=";
    };
    pil-squasher = pkgs.writeCBin "pil-squasher" (builtins.readFile "${pil-squasher-src}/pil-squasher.c");
  in [
    (pkgs.stdenv.mkDerivation {
      name = "firmware-fairphone-fp5";
      src = pkgs.fetchFromGitHub {
        owner = "FairBlobs";
        repo = "FP5-firmware";
        rev = "798524050d9f4802450cd4f1bf46ddd105b6ae4f";
        hash = "sha256-c/x9VwtlKyKp1vSRXJemyo9R3C3/E2o77c89FmBwTw8=";
      };
      phases = [ "unpackPhase" "installPhase" ];
      nativeBuildInputs = [
        pil-squasher
      ];
      installPhase = ''
        mkdir -p $out
        for i in *.mdt; do
          set -x
        	pil-squasher "$(basename "$i" .mdt)".mbn "$i"
          set +x
        done
  install -Dm644 a660_zap.mbn -t "$out/lib/firmware/qcom/qcm6490/fairphone5/"

	install -Dm644 adsp.mbn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	install -Dm644 adsp*.jsn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	install -Dm644 battmgr.jsn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	install -Dm644 msbtfw11.mbn -t \
		"$out/lib/firmware/qca/"
	install -Dm644 msnv11.bin -t \
		"$out/lib/firmware/qca/"
	install -Dm644 cdsp.mbn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	install -Dm644 cdsp*.jsn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	mkdir -p "$out"/usr/share/qcom/qcm6490/Fairphone/
	cp -r hexagonfs/ \
		"$out"/usr/share/qcom/qcm6490/Fairphone/fairphone5

	# Remove files that we don't need - for now
	rm -r "$out"/usr/share/qcom/qcm6490/Fairphone/fairphone5/acdb/
	rm -r "$out"/usr/share/qcom/qcm6490/Fairphone/fairphone5/dsp/

	find "$out/usr/share/qcom/qcm6490/Fairphone/fairphone5/" \
		-type f -exec chmod 0644 {} \;
	install -Dm644 yupik_ipa_fws.mbn \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/ipa_fws.mbn"

	install -Dm644 modem.mbn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	install -Dm644 modem*.jsn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"

	cp -r modem_pr/ \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"
	find "$out/lib/firmware/qcom/qcm6490/fairphone5/" \
		-type f -exec chmod 0644 {} \;
	install -Dm644 vpu20_1v.mbn \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/venus.mbn"

	install -Dm644 wpss.mbn -t \
		"$out/lib/firmware/qcom/qcm6490/fairphone5/"


        ls -lah
        '';
    })
  ];

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
