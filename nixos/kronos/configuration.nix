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
}