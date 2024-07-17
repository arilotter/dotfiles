{ pkgs, ... }:
{
  networking.hostName = "hermes";

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "ec_sys.write_support=1" ];
  };

  networking.firewall.allowedTCPPortRanges = [ ];

  services = {
    libinput.enable = true;

    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
  };
}
