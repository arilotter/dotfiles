{ lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
    plymouth.enable = true;
  };

  console = {
    keyMap = "us";
  };

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:super";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  virtualisation.docker.enable = true;

  environment.variables = { WLR_NO_HARDWARE_CURSORS = "1"; NIXOS_OZONE_WL = "1"; };

  services = {
    fwupd.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin brlaser ];
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}

