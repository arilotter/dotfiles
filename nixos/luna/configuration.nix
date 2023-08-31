{ config, pkgs, ... }:
{
  networking.hostName = "luna";


  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.importedVariables = [
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_DESKTOP"
    ];
  };
  powerManagement.cpuFreqGovernor = "performance";
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  programs.steam.enable = true;
}

