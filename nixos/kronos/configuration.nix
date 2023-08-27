{ pkgs, ... }:
{
  networking.hostName = "kronos";

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    enableRedistributableFirmware = true;
  };

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    i2c-tools
  ];

  networking.firewall.allowedTCPPortRanges = [
  ];

  services.openssh.enable = true;

  nix.settings.trusted-public-keys = [
    "ari-sol-builder-1:PBsq1rU3Xd/S+N3GatIWi82PFoeOqQdpaArZTns69aM="
  ];
}
