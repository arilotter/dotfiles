{
  inputs,
  pkgs,
  ...
}: {
  imports = [../mount-sol-samba-share.nix];
  networking.hostName = "hermes";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["ec_sys.write_support=1"];
  };

  networking.firewall.allowedTCPPortRanges = [];

  environment.systemPackages = [inputs.fw-inputmodule.packages.${pkgs.system}.default];
  programs.steam.enable = true;

  services = {
    libinput.enable = true;

    xserver = {
      videoDrivers = ["amdgpu"];
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
    };
  };
}
