{ lib, pkgs, ... }:
{
  nixpkgs = {
    overlays = [ ];
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
    plymouth.enable = true;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "FiraCode";
    keyMap = "us";
  };

  security = {
    polkit.enable = true;
  };

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:super";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  virtualisation.docker.enable = true;
  sound.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    socketActivation = true;
  };

  programs.fish.enable = true;
  programs.adb.enable = true;
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
      ];
      shell = pkgs.fish;
      hashedPassword = import ./hashedPassword.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    zip
    unzip
    fish
    nano
    fwupd
    nixfmt
  ];

  environment.variables = { WLR_NO_HARDWARE_CURSORS = "1"; NIXOS_OZONE_WL = "1"; };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  services = {
    fwupd.enable = true;
    pcscd.enable = true; # yubikey
    avahi = {
      enable = true;
      nssmdns = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint gutenprintBin brlaser ];
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.11";
}

