# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  system.copySystemConfiguration = true;
  boot.blacklistedKernelModules = [ "mei_me" ];
  imports = [
    <nixos-hardware/lenovo/thinkpad/x1/6th-gen/QHD>
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    wget nano fish git unzip mkpasswd ntfs3g p7zip dmidecode
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
  networking.firewall.allowedTCPPorts = [ 4001 3001 8000 ];
  networking.firewall.allowedUDPPorts = [];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable brightness control.
  programs.light.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.ari = {
      isNormalUser = true;
      home = "/home/ari";
      description = "Ari Lotter";
      extraGroups = [ "wheel" "sudoers" "audio" "video" "disk" "networkmanager"];
      uid = 1000;
      shell = pkgs.fish;
      hashedPassword = let hashedPassword = import ./hashedPassword.nix; in hashedPassword;
    };
    mutableUsers = false;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
