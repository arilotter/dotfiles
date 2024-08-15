{ config, pkgs, ... }:
{
  imports = [ ../mount-sol-samba-share.nix ];

  networking.hostName = "luna";

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

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  services.usbmuxd.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };
}
