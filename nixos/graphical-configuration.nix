{ pkgs, ... }:
{
  imports = [
    ./tuigreet.nix
    ./catppuccin.nix
  ];

  boot.plymouth.enable = true;

  console.keyMap = "us";

  services.xserver.xkb.layout = "us";

  security.pam.services.hyprlock = { };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  virtualisation = {
    docker.enable = true;
    # virtualbox.host = {
    #   enable = true;
    #   enableKvm = true;
    #   addNetworkInterface = false;
    # };
  };

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  services = {
    fwupd.enable = true;
    printing.enable = false;
  };

  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    liberation_ttf
    tex-gyre.heros
  ];
}
