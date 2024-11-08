{pkgs, ...}: {
  imports = [./tuigreet.nix];

  boot.plymouth.enable = true;

  console.keyMap = "us";

  services.xserver.xkb.layout = "us";

  security.pam.services.hyprlock = {};

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    config = {
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  virtualisation.docker = {
    enable = true;
  };

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  services = {
    fwupd.enable = true;
    printing.enable = false;
  };

  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})
    tex-gyre.heros
  ];
}
