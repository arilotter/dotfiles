# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  system.copySystemConfiguration = true;
  imports = [
    <nixos-hardware/lenovo/thinkpad/x1/6th-gen/QHD>
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  boot = {
    blacklistedKernelModules = [ "mei_me" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "sol"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget nano fish git unzip mkpasswd ntfs3g p7zip dmidecode thinkfan fwupd
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    (nerdfonts.override {
      withFont = "--complete FiraCode";
    })
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 4001 3001 8000 12345 ];
  networking.firewall.allowedUDPPorts = [ ];
  services = {
    fwupd.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint gutenprintBin brlaser
      ];
    };
    xserver = {
      enable = true;
      layout = "us";
      # Enable touchpad support.
      libinput.enable = true;

      displayManager.lightdm = {
        enable = true;
        autoLogin.enable = true;
        autoLogin.user = "ari";
      };
    };
  };
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable brightness control.
  programs.light.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.ari = {
      isNormalUser = true;
      home = "/home/ari";
      description = "Ari Lotter";
      extraGroups = [ "wheel" "sudoers" "audio" "video" "disk" "networkmanager" ];
      uid = 1000;
      shell = pkgs.fish;
      hashedPassword = let hashedPassword = import ./hashedPassword.nix; in hashedPassword;
    };
    mutableUsers = false;
  };

  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=70
    STOP_CHARGE_THRESH_BAT0=100
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';
  services.thinkfan = {
    enable = true;
    sensors = ''
      hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp3_input
      hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp4_input
      hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input
      hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp5_input
      hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp2_input
      hwmon /sys/devices/virtual/thermal/thermal_zone2/hwmon0/temp1_input
      hwmon /sys/devices/virtual/thermal/thermal_zone6/hwmon4/temp1_input
      hwmon /sys/devices/virtual/thermal/thermal_zone4/hwmon2/temp1_input
    '';
    levels = ''
      (0,	0,	55)
      (1,	48,	60)
      (2,	50,	61)
      (3,	52,	63)
      (4,	56,	65)
      (5,	59,	66)
      (7,	63,	32767)
    '';
  };
  system.stateVersion = "18.09";
}
