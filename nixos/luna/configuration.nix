{ config, pkgs, ... }:
{
  networking.hostName = "luna";

  imports = [ ./hardware-configuration.nix ];

  nixpkgs = {
    overlays = [ ];
    config.allowUnfree = true;
  };

  nix = {
    # # Add each flake input as a registry
    # # To make nix3 commands consistent with flake
    # registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # # Add inputs to the system's legacy channels
    # # Making legacy nix commands consistent as well
    # nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    blacklistedKernelModules = [ "snd_hda_codec_hdmi" ];

    supportedFilesystems = [ "ntfs" ];
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "FiraCode";
    keyMap = "us";
  };

  security.polkit.enable = true;

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:super";
    videoDrivers = [ "nvidia" ];
    displayManager.importedVariables = [
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_DESKTOP"
    ];
  };
powerManagement.cpuFreqGovernor = "performance";
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
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

  programs.steam.enable = true;
  programs.fish.enable = true;
  users.users.ari = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "docker"
      "dialout"
      "sway"
      "video"
    ];
    shell = pkgs.fish;
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

  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.openssh.enable = false;

  networking.firewall.allowedTCPPorts = [ 24800 ];
  networking.firewall.allowedUDPPorts = [ 24800 ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.11";

}

