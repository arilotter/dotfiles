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
      driSupport = true;
      driSupport32Bit = true;
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "ec_sys.write_support=1" ];
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
        lemurs.enable = true;
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
}
