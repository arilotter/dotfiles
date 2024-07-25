{ lib, config, ... }: {
  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    loader.systemd-boot.enable = true;
  };


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/275aff46-c75d-49a8-a709-c095dd69c73d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0DB3-17EA";
    fsType = "vfat";
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/D4B0-B27D";
    fsType = "exfat";
    options = [ "users" "rw" "nofail" "dir_mode=0777" "file_mode=0777" ];
  };

  networking.useDHCP = lib.mkDefault true;


  swapDevices = [ ];


  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
