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
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  services = {
    pcscd.enable = true; # yubikey
    avahi = {
      enable = true;
      nssmdns = true;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "21.11";
}

