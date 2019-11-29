# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, options, lib, ... }:
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
    kernelParams = ["ec_sys.write_support=1"];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  networking = {
    hostName = "sol"; # Define your hostname.
    networkmanager.enable = true;
    networkmanager.appendNameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
  };
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
    zip
    unzip
    mkpasswd
    ntfs3g
    p7zip
    dmidecode
    thinkfan
    fwupd
    xorg.xinit
    libfido2
    limesuite

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
  fonts.fontconfig.dpi = 140;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 1337 4001 3000 3001 8000 12345 8080 ];

  # For Chromecast :|
  networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];

  services = {
    fwupd.enable = true;
    pcscd.enable = true; # yubikey
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

      dpi = 210;
      monitorSection = ''
          DisplaySize 310 174   # In millimeters
      '';
      videoDrivers = [ "intel" ];
      deviceSection = ''
        Option "TearFree" "true"
        Option "DRI" "2"
        Option "Backlight" "intel_backlight"
      '';
      displayManager.startx.enable = true;
    };
    usbmuxd.enable = true;
    udev = {
      # auto lock when pulling out yubikey
      extraRules = ''
        ACTION=="remove", ENV{ID_BUS}=="usb", ENV{ID_MODEL_ID}=="0407", ENV{ID_VENDOR_ID}=="1050", ENV{ID_REVISION}=="0512", RUN+="${
          pkgs.writeShellScript "lock_user_screen_as_root" ''
            #!/usr/bin/env bash
            LOCKFILE=/tmp/screen.lock
            if [[ -f "$LOCKFILE" ]]; then
                echo "$LOCKFILE exist"
                exit 0
            fi
            #/run/wrappers/bin/su - ari -c "export DISPLAY=:0; /home/ari/.nix-profile/bin/maim /tmp/screen.png; /home/ari/.nix-profile/bin/xwobf -s 11 /tmp/screen.png; /home/ari/.nix-profile/bin/i3lock -i /tmp/screen.png;" > /tmp/wtf.log 2>&1
            #rm /tmp/screen.png
            rm /tmp/screen.lock
          ''
        }"
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057E", ATTRS{idProduct}=="0337", MODE="0666"
      '';
    };
  };
  virtualisation.docker.enable = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [
      pkgs.pulseaudio-modules-bt
    ];
  };

  programs.light.enable = true;

  programs.adb.enable = true;
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.ssh.startAgent = false;

  # powerManagement.powerDownCommands = ''echo "`id` $SHELL AAAAAA I WENT TO SLEEP" > /dev/kmsg'';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.ari = {
      isNormalUser = true;
      home = "/home/ari";
      description = "Ari Lotter";
      extraGroups = [ "wheel" "sudoers" "audio" "video" "disk" "networkmanager" "adbusers" "docker"];
      uid = 1000;
      shell = pkgs.fish;
      hashedPassword = let hashedPassword = import ./hashedPassword.nix; in hashedPassword;
    };
    mutableUsers = false;
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=90
      STOP_CHARGE_THRESH_BAT0=100
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      ENERGY_PERF_POLICY_ON_BAT=powersave
      CPU_SCALING_GOVERNOR_ON_AC=balance-performance
      ENERGY_PERF_POLICY_ON_AC=balance-performance
    '';
  };

  # Disable the "throttling bug fix" -_- https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/cpu-throttling-bug.nix
  systemd.timers.cpu-throttling.enable = lib.mkForce false;
  systemd.services.cpu-throttling.enable = lib.mkForce false;
  system.stateVersion = "19.09";
}
