{ lib, pkgs, config, ... }:
{
  fileSystems."/".device = "/dev/disk/by-partlabel/userdata";
  fileSystems."/".fsType = "ext4";

  system.build.rootfsImage = pkgs.callPackage "${pkgs.path}/nixos/lib/make-ext4-fs.nix" {
    storePaths = config.system.build.toplevel;
    compressImage = false;
    volumeLabel = "nixos";
  };

#  boot.initrd.compressor = "zstd";

  boot.loader.grub.enable = false;

  nixpkgs.config.allowUnfree = true;
  networking.firewall.enable = false;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 90;
  };
  #hardware.graphics = {
  #  enable = true;
  #  extraPackages = with pkgs; [
  #    vulkan-loader
  #    vulkan-validation-layers
  #    vulkan-extension-layer
  #  ];
  #};
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

  environment.systemPackages = with pkgs; [
    vim
    git
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
