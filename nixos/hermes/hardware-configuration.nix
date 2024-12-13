{
  lib,
  pkgs,
  config,
  ...
}: {
  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "thunderbolt"
      "usb_storage"
      "sd_mod"
      "usbhid"
    ];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2d3cdcb4-8a76-4f8c-939c-3912abc2c673";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C9F2-4EC9";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  networking.useDHCP = lib.mkDefault true;

  # arguably useless on consumer ryzen hardware.
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # this crashed the laptop
  # hardware.opengl.extraPackages = with pkgs.rocmPackages_5; [
  #     clr.icd
  #     clr
  #     rocminfo
  #     rocm-runtime
  #   ];
  # # This is necesery because many programs hard-code the path to hip
  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  # ];

  nix.settings.max-jobs = lib.mkDefault 16;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
