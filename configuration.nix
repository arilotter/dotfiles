# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, options, ... }:
{
  system.copySystemConfiguration = true;
  imports = [
    <nixos-hardware/lenovo/thinkpad/x1/6th-gen>
    ./hardware-configuration.nix
  ];
  nix.nixPath =
    options.nix.nixPath.default ++ 
    # Add the overlays file to read from 'nixpkgs.overlays' in this file
    [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ]
  ;
  nixpkgs.overlays = [
    (self: super: {
      libplist = self.callPackage /home/ari/src/nixpkgs/pkgs/development/libraries/libplist { };
      libusbmuxd = self.callPackage /home/ari/src/nixpkgs/pkgs/development/libraries/libusbmuxd { };
      libimobiledevice = self.callPackage /home/ari/src/nixpkgs/pkgs/development/libraries/libimobiledevice { };
      usbmuxd = self.callPackage /home/ari/src/nixpkgs/pkgs/tools/misc/usbmuxd { };
      ios-webkit-debug-proxy = self.callPackage /home/ari/src/nixpkgs/pkgs/development/mobile/ios-webkit-debug-proxy { };
    })
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  
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
    consoleFont = "Fira Code";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bluez
    wget
    nano
    fish
    git
    unzip
    mkpasswd
    ntfs3g
    p7zip
    dmidecode
    thinkfan
    fwupd
    xorg.xinit
    (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
 ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    tewi-font
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
        extraConfig = ''
          [XDMCPServer]
          enabled=true
        '';
      };
    };
    openssh = {
      enable = false;
      forwardX11 = true;
    };
    usbmuxd.enable = true;
  };
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [
      pkgs.pulseaudio-modules-bt
    ];
  };

  # Enable brightness control.
  programs.light.enable = true;

  programs.ssh.forwardX11 = true;

  programs.adb.enable = true;

  virtualisation.lxd.enable = true;

  # powerManagement.powerDownCommands = ''echo "`id` $SHELL AAAAAA I WENT TO SLEEP" > /dev/kmsg'';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.ari = {
      isNormalUser = true;
      home = "/home/ari";
      description = "Ari Lotter";
      extraGroups = [ "wheel" "sudoers" "audio" "video" "disk" "networkmanager" "lxd" "adbusers"];
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
  system.stateVersion = "18.09";
}
