{
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs = {
    overlays = [inputs.nur.overlay];
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  boot = {
    # disable modules that conflict w/ smart card reader.
    blacklistedKernelModules = [
      "nfc"
      "pn533"
      "pn533_usb"
    ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_6_10;
    supportedFilesystems = ["ntfs"];
    binfmt.emulatedSystems = ["aarch64-linux"];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";

  security.polkit.enable = true;

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
    cachix
    wget
    git
    zip
    unzip
    fish
    nano
    kitty # even on non-graphical systems, this installs terminfo.
    alejandra # nix fmtter
    nil
    steam-run
    inputs.agenix.packages.${pkgs.system}.default
  ];

  services = {
    fido2-hid-bridge.enable = true;

    pcscd = {
      enable = true; # yubikey / hand
      plugins = [pkgs.acsccid];
    };

    gnome.gnome-keyring.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
        hinfo = true;
        domain = true;
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

  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
