{ pkgs, ... }:
{
  networking.hostName = "sol";

  hardware = {
    nvidia = {
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    cpu.intel.updateMicrocode = true;
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "ec_sys.write_support=1" ];
    extraModprobeConfig = ''
      # allows changing other nvidia kernel params
      options nvidia NVreg_RegistryDwords="OverrideMaxPerf=0x1"

      # Fixes broken sleep on wayland
      # https://github.com/hyprwm/Hyprland/issues/1728#issuecomment-1571852169
      options nvidia NVreg_PreserveVideoMemoryAllocations=1
    '';
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];


  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [
    { from = 2999; to = 3001; }
    { from = 8079; to = 8081; }
    { from = 4002; to = 4002; }
  ];

  services = {
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

      videoDrivers = [ "nvidia" ];
      displayManager = {
        sddm.enable = true;
        importedVariables = [
          "XDG_SESSION_TYPE"
          "XDG_CURRENT_DESKTOP"
          "XDG_SESSION_DESKTOP"
        ];
        defaultSession = "hyprland";
        session = [{
          name = "hyprland";
          manage = "desktop";
          start = ''exec Hyprland'';
        }];
      };
    };
    usbmuxd.enable = true;
  };
  nix.extraOptions = ''
    secret-key-files = /home/ari/nix-secret-key
  '';
}
