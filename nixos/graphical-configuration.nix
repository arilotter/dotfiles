{ lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
    plymouth.enable = true;
  };

  console.keyMap = "us";

  services.xserver.xkb.layout = "us";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  programs.hyprland.enable = true;

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    # extraOptions = "--default-runtime=nvidia";
  };

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

