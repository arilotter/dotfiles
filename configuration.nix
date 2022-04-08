{ config, pkgs, options, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  system.copySystemConfiguration = true;
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.packageOverrides = pkgs: {
    stable = import <nixos-stable> { config = config.nixpkgs.config; };
  };
  hardware.nvidia = {
    # package = config.boot.kernelPackages.nvidiaPackages.beta.override ({
    #   patches = [
    #     lib.fetchurl
    #     "https://gist.githubusercontent.com/joanbm/144a965c36fc1dc0d1f1b9be3438a368/raw/73c41bc2910e1df24fcc34c6ebb9945ba7677fee/nvidia-fix-linux-5.14.patch"
    #   ];
    # });
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  environment.variables.XCURSOR_SIZE = "32";
  environment.variables.XCURSOR_THEME = "Adwaita";
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "ec_sys.write_support=1" ];
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  networking = {
    hostName = "sol"; # Define your hostname.
    networkmanager.enable = true;
    networkmanager.appendNameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
  };

  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    font = "Fira Code";
    keyMap = "us";
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
    dmidecode
    thinkfan
    fwupd
    xorg.xinit
    libfido2
    limesuite
    linuxPackages.v4l2loopback
    nixfmt
    gnome3.adwaita-icon-theme
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    tewi-font
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [{
    from = 0;
    to = 60999;
  }
    { from = 2999; to = 3001; }
    { from = 8079; to = 8081; }];

  # For Chromecast :|
  networking.firewall.allowedUDPPortRanges = [{
    from = 0;
    to = 60999;
  }];

  services = {
    sshd = {
      enable = true;
    };
    openssh = {
      enable = true;
      forwardX11 = true;
    };
    fwupd.enable = true;
    pcscd.enable = true; # yubikey
    gnome3.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin brlaser ];
    };
    xserver = {
      enable = true;
      layout = "us";
      # Enable touchpad support.
      libinput.enable = true;

      dpi = 282;
      monitorSection = ''
        DisplaySize 345 194 # In millimeters
      '';
      deviceSection = ''
        Option  "RegistryDwords"  "EnableBrightnessControl=1"
      '';
      displayManager.startx.enable = true;

      videoDrivers = [ "nvidia" ];
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
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };


  programs.light.enable = true;

  programs.adb.enable = true;

  programs.system-config-printer.enable = true;

  security.sudo = {
    enable = true;
    configFile = ''
      Defaults  insults
    '';
  };


  # powerManagement.powerDownCommands = ''echo "`id` $SHELL AAAAAA I WENT TO SLEEP" > /dev/kmsg'';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.ari = {
      isNormalUser = true;
      home = "/home/ari";
      description = "Ari Lotter";
      extraGroups = [
        "wheel"
        "sudoers"
        "audio"
        "video"
        "disk"
        "networkmanager"
        "adbusers"
        "docker"
      ];
      uid = 1000;
      shell = pkgs.fish;
      hashedPassword =
        let hashedPassword = import ./hashedPassword.nix;
        in hashedPassword;
    };
    mutableUsers = false;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
    };
  };
  # Disable the "throttling bug fix" -_- https://github.com/NixOS/nixos-hardware/blob/master/common/pc/laptop/cpu-throttling-bug.nix
  systemd.timers.cpu-throttling.enable = lib.mkForce false;
  systemd.services.cpu-throttling.enable = lib.mkForce false;
  services.logind.extraConfig = ''
    RuntimeDirectorySize=25%
    IdleActionSec=10000000
  '';
  system.stateVersion = "19.09";
}
