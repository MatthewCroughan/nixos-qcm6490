# This file is in the gitignore, changes will be ignored. It exists so changes
# can be tested but not committed accidentally.
{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];
  boot.kernelParams = [
    "iommu=soft"
    "clk_ignore_unused"
    "pd_ignore_unused"
    "arm64.nopauth"
  ];
  boot.loader.systemd-boot.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  nixpkgs.config.allowUnfree = true;
  users.mutableUsers = false;
  users.users.root.password = "default";
  users.users.matthew = {
    password = "0000";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOJDRQfb1+7VK5tOe8W40iryfBWYRO6Uf1r2viDjmsJtAAAABHNzaDo= backup-yubikey"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDgsWq+G/tcr6eUQYT7+sJeBtRmOMabgFiIgIV44XNc6AAAABHNzaDo= main-yubikey"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJMi3TAuwDtIeO4MsORlBZ31HzaV5bji1fFBPcC9/tWuAAAABHNzaDo= nano-yubikey"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJXGRXiq61BQBUkQLBn720pzxiAZqchHWm504gWa2rE2"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOu1koO8pJ6t0I+rpSVfjD1m6eDk9KTp8cvGL500tsQ9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKZfejb9htpSB5K9p0RuEowErkba2BMKaze93ZVkQIE"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJXGRXiq61BQBUkQLBn720pzxiAZqchHWm504gWa2rE2"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOu1koO8pJ6t0I+rpSVfjD1m6eDk9KTp8cvGL500tsQ9"

    ];
    isNormalUser = true;
    extraGroups = [
      "feedbackd"
      "networkmanager"
      "input"
      "lp"
      "wheel"
      "dialout"
      "kvm"
      "plugdev"
      "audio"
      "pipewire"
      "video"
    ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 90;
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
      trusted-users = [
        "@wheel"
        "root"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };
  networking.firewall.enable = false;
  systemd.services.phosh.environment.XDG_PICTURES_DIR = "/tmp";
  services.xserver.desktopManager.phosh = {
    enable = true;
    group = "users";
    user = "matthew";
  };
  hardware.bluetooth.package =
    (builtins.getFlake "github:nixos/nixpkgs/fc756aa6f5d3e2e5666efcf865d190701fef150a")
    .legacyPackages.aarch64-linux.bluez;
  programs.feedbackd.enable = true;
  programs.calls.enable = true;
  hardware.sensor.iio.enable = true;
  environment.systemPackages = with pkgs; [
    hexagonrpc
    snapshot
    # Disabled since it uses `olm` which was marked insecure.
    #chatty              # IM and SMS
    snapshot
    epiphany # Web browser
    gnome-console # Terminal

    qrtr
    rmtfs
    qmic
    tqftpserv
  ];
  systemd.services.iio-sensor-proxy.serviceConfig.RestrictAddressFamilies = [
    "AF_QIPCRTR"
    "AF_LOCAL"
  ];
  systemd.services.iio-sensor-proxy.overrideStrategy = "asDropin";

  systemd.services.hexagonrpcd-adsp-sensorspd = {
    description = "Daemon to support Qualcomm Hexagon ADSP virtual filesystem for SensorPD";
    wantedBy = [ "multi-user.target" ];
    before = [ "suspend.target" ];
    conflicts = [ "suspend.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.hexagonrpc}/bin/hexagonrpcd -f /dev/fastrpc-adsp -d adsp -s";
      Restart = "on-failure";
      # This service shouldn't be run on devices with an SDSP
      ConditionPathExists = [
        "!/dev/fastrpc-sdsp"
        "/dev/fastrpc-adsp"
      ];
      RestartSec = "3s";
      # maybe use dynamicuser
      User = "root";
      Group = "root";
    };
  };

  systemd.services.tqftpserv = {
    description = "Qualcomm QRTR TFTP services (tqftpserv)";
    wantedBy = [ "multi-user.target" ];
    before = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.tqftpserv}/bin/tqftpserv";
      Restart = "on-failure";
      RestartSec = "2s";
      # maybe use dynamicuser
      User = "root";
      Group = "root";
    };
  };
  systemd.services.rmtfs = {
    description = "Qualcomm Remote Filesystem Daemon (rmtfs)";
    wantedBy = [ "multi-user.target" ];
    before = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.rmtfs}/bin/rmtfs -r -P -s";
      Restart = "on-failure";
      RestartSec = "2s";
      # maybe use dynamicuser
      User = "root";
      Group = "root";
    };
  };
  # Maybe not needed because it's in kernel now
  #systemd.services.pd-mapper = {
  #  description = "Qualcomm Protection Domain Mapper (pd-mapper)";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];

  #  serviceConfig = {
  #    ExecStart = "${pkgs.pd-mapper}/bin/pd-mapper";
  #    Restart = "on-failure";
  #    RestartSec = "2s";
  #    # maybe use dynamicuser
  #    User = "root";
  #    Group = "root";
  #  };
  #};
  networking.modemmanager.enable = true;
  services.udev.extraRules = ''
    # iio-sensor-proxy with libssc: accelerometer mount matrix
    SUBSYSTEM=="misc", KERNEL=="fastrpc-*", ENV{ACCEL_MOUNT_MATRIX}+="-1, 0, 0; 0, -1, 0; 0, 0, -1"
  '';
  nixpkgs.overlays = [
    (self: super: {
    })
  ];
  systemd.services.qca-bluetooth =
    let
      script = pkgs.writeShellScript "qca-bluetooth.sh" ''
        set -x
        trap 'sleep 1' DEBUG # Sleep 1 second before every command execution
        export PATH="${
          lib.makeBinPath (
            with pkgs;
            [
              config.hardware.bluetooth.package
              coreutils-full
              gawk
              unixtools.script
            ]
          )
        }:$PATH"

        SERIAL=$(grep -o "serialno.*" /proc/cmdline | cut -d" " -f1)
        BT_MAC=$(echo "$SERIAL-BT" | sha256sum | awk -v prefix=0200 '{printf("%s%010s\n", prefix, $1)}')
        BT_MAC=$(echo "$BT_MAC" | cut -c1-12 | sed 's/\(..\)/\1:/g' | sed '$s/:$//')

        script -qc "btmgmt --timeout 3 -i hci0 power off"
        script -qc "btmgmt --timeout 3 -i hci0 public-addr \"$BT_MAC\""
      '';
    in
    {
      description = "Setup the bluetooth interface";
      wantedBy = [
        "multi-user.target"
        "bluetooth.service"
      ];
      script = toString script;
      serviceConfig = {
        User = "root";
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
    services.flatpak.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "matthew" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  services.tailscale.enable = true;
  xdg.portal.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  services.xserver.updateDbusEnvironment = true;
  environment.pathsToLink = [
    "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
  ];

  # imports = [ ./radvd.nix ];
  services.yggdrasil = {
    enable = true;
    openMulticastPort = true;
    persistentKeys = true;
    settings = {
      "Peers" = [
        "tls://bidstonobservatory.org:993"
        "tls://uk1.servers.devices.cwinfo.net:28395"
        "tls://51.38.64.12:28395"
        "tcp://88.210.3.30:65533"
        "tcp://s2.i2pd.xyz:39565"
        "tcp://s-kzn-0.sergeysedoy97.ru:65533"
        "tls://supergay.network:443"
      ];
      "MulticastInterfaces" = [
        {
          "Regex" = "w.*";
          "Beacon" = true;
          "Listen" = true;
          "Port" = 9001;
          "Priority" = 0;
        }
      ];
      "AllowedPublicKeys" = [];
      "IfName" = "auto";
      "IfMTU" = 65535;
      "NodeInfoPrivacy" = false;
      "NodeInfo" = null;
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod.enable = false;
}
