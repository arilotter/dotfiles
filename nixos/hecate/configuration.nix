{
  config,
  pkgs,
  ...
}:
{
  networking.hostName = "hecate";

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    displayManager.importedVariables = [
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_DESKTOP"
    ];
  };
  powerManagement.cpuFreqGovernor = "performance";
  # enable OpenCL
  hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };
}
