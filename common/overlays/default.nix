{
  nixpkgs.overlays = [
    (self: super: {
      iio-sensor-proxy = super.iio-sensor-proxy.overrideAttrs (old: {
        patches = old.patches ++ [
#	./0001-iio-sensor-proxy-depend-on-libssc.patch
	        ../patches/iio-sensor-proxy/0001-WIP-iio-sensor-proxy.c-Do-not-exit-based-on-sensor-e.patch
	        ../patches/iio-sensor-proxy/0002-proximity-support-SSC-proximity-sensor.patch
	        ../patches/iio-sensor-proxy/0003-light-support-SSC-light-sensor.patch
	        ../patches/iio-sensor-proxy/0004-accelerometer-support-SSC-accelerometer-sensor.patch
	        ../patches/iio-sensor-proxy/0005-compass-support-SSC-compass-sensor.patch
	        ../patches/iio-sensor-proxy/0006-data-add-libssc-udev-rules.patch
	        ../patches/iio-sensor-proxy/0007-data-iio-sensor-proxy.service.in-add-AF_QIPCRTR.patch
	        ../patches/iio-sensor-proxy/0008-drv-ssc-implement-set_polling.patch
	        ../patches/iio-sensor-proxy/0009-tests-integration-test-add-SSC-sensors.patch
	        ../patches/iio-sensor-proxy/0013-integration-test-add-test-for-sensors-that-report-no.patch
        ];
      });
      #hexagonrpc = super.callPackage ./hexagonrpc.nix {};
      #qrtr = super.callPackage ./qrtr/qrtr.nix {};
      #qmic = super.callPackage ./qrtr/qmic.nix {};
      #rmtfs = super.callPackage ./qrtr/rmtfs.nix {};
      #tqftpserv = super.callPackage ./qrtr/tqftpserv.nix {};
      #pd-mapper = super.callPackage ./qrtr/pd-mapper.nix {};
    })
  ];
}
