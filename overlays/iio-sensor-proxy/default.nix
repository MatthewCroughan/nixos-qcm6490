final: prev: {
  iio-sensor-proxy = prev.iio-sensor-proxy.overrideAttrs (old: {
    patches = old.patches ++ [
      ./0001-WIP-iio-sensor-proxy.c-Do-not-exit-based-on-sensor-e.patch
      ./0002-proximity-support-SSC-proximity-sensor.patch
      ./0003-light-support-SSC-light-sensor.patch
      ./0004-accelerometer-support-SSC-accelerometer-sensor.patch
      ./0005-compass-support-SSC-compass-sensor.patch
      ./0006-data-add-libssc-udev-rules.patch
      ./0007-data-iio-sensor-proxy.service.in-add-AF_QIPCRTR.patch
      ./0008-drv-ssc-implement-set_polling.patch
      ./0009-tests-integration-test-add-SSC-sensors.patch
      ./0013-integration-test-add-test-for-sensors-that-report-no.patch
    ];
  });
}
