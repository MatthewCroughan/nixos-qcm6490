# This file is in the gitignore, changes will be ignored. It exists so changes
# can be tested but not committed accidentally.
{ pkgs, ... }:
{
  services.xserver.desktopManager.phosh = {
    enable = true;
    group = "users";
    user = "matthew";
  };
  programs.feedbackd.enable = true;
  programs.calls.enable = true;
  hardware.sensor.iio.enable = true;
  environment.systemPackages = with pkgs; [
    hexagonrpc
    snapshot
    # Disabled since it uses `olm` which was marked insecure.
    #chatty              # IM and SMS
    snapshot
    epiphany            # Web browser
    squeekboard
    gnome-console       # Terminal

    qrtr
    rmtfs
    qmic
    tqftpserv
  ];
  users.users."matthew" = {
    isNormalUser = true;
#    password = "1234";
    extraGroups = [
      "dialout"
      "feedbackd"
      "networkmanager"
      "video"
      "wheel"
      "feedbackd"
    ];
  };

  systemd.services.iio-sensor-proxy.serviceConfig.RestrictAddressFamilies = [ "AF_QIPCRTR" "AF_LOCAL" ];
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
      ConditionPathExists = [ "!/dev/fastrpc-sdsp" "/dev/fastrpc-adsp" ];
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
  nixpkgs.overlays = [ (self: super: {
  }) ];
}
