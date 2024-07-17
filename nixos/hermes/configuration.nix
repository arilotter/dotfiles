{ inputs, pkgs, ... }:
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

  environment.systemPackages = [
    inputs.fw-inputmodule.packages.${pkgs.system}.default
  ];

  services = {
    libinput.enable = true;

    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
  };
}
