{
  nixpkgs.overlays = [
    (self: super: {
      stevia = super.callPackage ./stevia.nix {};
      mdm = super.callPackage ./mdm.nix {};
      firmware-shift-otter = super.callPackage ./firmware-shift-otter {};
      firmware-fairphone-fp5 = super.callPackage ./firmware-fairphone-fp5 {};
      linuxPackages_sc7280-mainline = super.linuxPackagesFor (super.callPackage ./linux-sc7280-mainline {});
      pil-squasher = super.callPackage ./pil-squasher {};
      #hexagonrpc = super.callPackage ./hexagonrpc.nix {};
      #qrtr = super.callPackage ./qrtr/qrtr.nix {};
      #qmic = super.callPackage ./qrtr/qmic.nix {};
      #rmtfs = super.callPackage ./qrtr/rmtfs.nix {};
      #tqftpserv = super.callPackage ./qrtr/tqftpserv.nix {};
      #pd-mapper = super.callPackage ./qrtr/pd-mapper.nix {};
    })
  ];
}
