{
  config,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [ "nvidia-drm.fbdev=1" ];
    blacklistedKernelModules = [
      "snd_hda_codec_hdmi"
      "nfc"
    ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d362fcde-2176-4e99-a5c6-1bc4180fb4a0";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C0DD-9170";
    fsType = "vfat";
  };

  networking.useDHCP = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile2";
      size = 128 * 1024;
    }
  ];
}
