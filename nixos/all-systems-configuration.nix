{ lib, pkgs, ... }:
{
  nixpkgs = {
    overlays = [ ];
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      trusted-users = [ "root" "ari" ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # disable modules that conflict w/ smart card reader.
  boot.blacklistedKernelModules = [ "nfc" "pn533" "pn533_usb" ];

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    polkit.enable = true;
  };

  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    socketActivation = true;
    wireplumber.enable = true;
  };

  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.enableRedistributableFirmware = true;

  programs.fish.enable = true;
  programs.adb.enable = true;
  programs.dconf.enable = true;
  users = {
    mutableUsers = false;
    users.ari = {
      isNormalUser = true;
      home = "/home/ari";
      description = "Ari Lotter";
      uid = 1000;
      extraGroups = [
        "wheel"
        "sudoers"
        "networkmanager"
        "adbusers"
        "audio"
        "docker"
        "dialout"
        "video"
        "wireshark"
      ];
      shell = pkgs.fish;
      hashedPassword = import ./hashedPassword.nix;
      openssh.authorizedKeys.keys = import ./physicalSSHKeys.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    zip
    unzip
    fish
    nano
    kitty # even on non-graphical systems, this installs terminfo.
    nixfmt-rfc-style
  ];

  services = {
    pcscd =
      {
        enable = true; # yubikey
        plugins = [ pkgs.acsccid ];
      };
    avahi = {
      enable = true;
      nssmdns4 = true;
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
    udev.extraRules = ''
      # udev rules for ACS CCID devices - NFC card reader.

      # If not adding the device, go away
      ACTION!="add", GOTO="pcscd_acsccid_rules_end"
      SUBSYSTEM!="usb", GOTO="pcscd_acsccid_rules_end"
      ENV{DEVTYPE}!="usb_device", GOTO="pcscd_acsccid_rules_end"

      # set USB power management to auto.
      ENV{ID_USB_INTERFACES}==":0b0000:", TEST=="power/control", ATTR{power/control}="auto"

      # All done
      LABEL="pcscd_acsccid_rules_end"
    '';
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.11";
}

