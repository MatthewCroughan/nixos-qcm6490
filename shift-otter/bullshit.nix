{ pkgs, lib, config, ... }:
{
  imports = [
    ./pipewire.nix
  ];
  services.fwupd.enable = true;
#  services.journald.storage = "volatile";
  boot.kernelParams = [
#    "msm.dpu_use_virtual_planes=0"
#    "msr.psr_enabled=0"
    "loglevel=8"
#     "msm.prefer_mdp5"
#     "msm.modeset=0"
#    "clk_ignore_unused"
#    "pd_ignore_unused"
#    "arm64.nopauth"
#    "iommu=soft"
#    "irqpoll"
  ];
  services.udev.extraRules = ''
    # Nreal Air Glasses
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3318", ATTRS{idProduct}=="0424", GROUP="input", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3318", ATTRS{idProduct}=="0424", GROUP="input", MODE="0666"
  '';

  nixpkgs.overlays = [
    (self: super: {
#      linux-firmware = (builtins.getFlake "github:nixos/nixpkgs/47310185099a0e40bb77c16793185c90ed5f3ace").legacyPackages.aarch64-linux.linux-firmware;
#      mesa = super.mesa.overrideAttrs (old: {
#        buildInputs = old.buildInputs ++ [ super.libdisplay-info ];
#        src = super.fetchFromGitLab {
#          domain = "gitlab.freedesktop.org";
#          owner = "mesa";
#          repo = "mesa";
#          rev = "4e762df66436d64090e9356a1a7078aa3c7b9a1e";
#          hash = "sha256-+CJ9zCEF3vNuqWhp+6uVcWzOfz6kL53DhpWAcwIgpmo=";
#        };
#      });
##      wlx-overlay-s = pkgs.callPackage ./wlx.nix {};
#      monado = super.callPackage ./monado.nix {};
#      monado = super.monado.overrideAttrs {
#        # opencv4 = null;
#        patches = [];
#        src = pkgs.fetchgit {
#          url = "https://gitlab.freedesktop.org/openglfreak/monado.git";
#          rev = "f89b39a0108e8ee0953f3a0068604655ab7f5bae";
#          hash = "sha256-dyHbIblR8r7vOZcZaSaXPO+XCeiD+s413UZ+Ok/4/6w=";
#        };
#      };
    })
  ];
#  nixpkgs.config.allowBroken = true;
  services.tailscale.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
#  networking.modemmanager.enable = true;
#  boot.kernelPatches = [
#    {
#      name = "drm-edid-xreal";
#      patch = ./edid.patch;
##      patch = pkgs.fetchpatch {
##        name = "drm-edid-xreal.patch";
##        url = "https://lore.kernel.org/dri-devel/20241028221055.778851-1-contact@scrumplex.net/raw";
##        hash = "sha256-nIBQST+k/HBbsWYDFvHlWWgxXUuJDY/xwe4i5YwpsnE=";
##      };
#    }
#  ];
#  services.monado.package = pkgs.callPackage ./monado.nix { inherit (pkgs.gst_all_1) gstreamer gst-plugins-base; };
  services.monado.enable = true;
  services.monado.defaultRuntime = true;

  systemd.user.services.monado.environment = {
    XRT_COMPOSITOR_DESIRED_MODE = "0";
    XRT_MESH_SIZE = "32";
#    XRT_COMPOSITOR_FORCE_VK_DISPLAY = "1";
#    XRT_COMPOSITOR_WAYLAND_CONNECTOR = "DP-1";
#    XRT_COMPOSITOR_FORCE_GPU_INDEX = "0";
#    STEAMVR_LH_ENABLE = "1";
#    XRT_COMPOSITOR_COMPUTE = "1";
  };

  environment.systemPackages = [
    pkgs.wlx-overlay-s
#    pkgs.librewolf
    pkgs.wmenu
    pkgs.foot
    pkgs.iwgtk
  ];
  hardware.graphics.extraPackages = with pkgs; [ monado-vulkan-layers ];
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
  programs.sway.enable = true;
  programs.sway.package = pkgs.sway.override { enableXWayland = false; };

  systemd.services.qca-bluetooth = let
    script = pkgs.writeShellScript "qca-bluetooth.sh" ''
      set -x
      trap 'sleep 1' DEBUG # Sleep 1 second before every command execution
      export PATH="${lib.makeBinPath (with pkgs; [ config.hardware.bluetooth.package coreutils-full gawk unixtools.script ])}:$PATH"

      SERIAL=$(grep -o "serialno.*" /proc/cmdline | cut -d" " -f1)
      BT_MAC=$(echo "$SERIAL-BT" | sha256sum | awk -v prefix=0200 '{printf("%s%010s\n", prefix, $1)}')
      BT_MAC=$(echo "$BT_MAC" | cut -c1-12 | sed 's/\(..\)/\1:/g' | sed '$s/:$//')

      script -qc "btmgmt --timeout 3 -i hci0 power off"
      script -qc "btmgmt --timeout 3 -i hci0 public-addr \"$BT_MAC\""
    '';
  in {
    description = "Setup the bluetooth interface";
    wantedBy = [ "multi-user.target" "bluetooth.service" ];
    script = toString script;
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
