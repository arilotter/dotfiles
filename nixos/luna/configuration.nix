{
  config,
  pkgs,
  ...
}:
let
  nvidiaProfile = builtins.readFile ./nvidia-wayland-fix.json;
in
{
  networking.hostName = "luna";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.importedVariables = [
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
      "XDG_SESSION_DESKTOP"
    ];
  };
  powerManagement.cpuFreqGovernor = "performance";
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    nvidiaSettings = true;
  };
  environment.etc."nvidia/nvidia-application-profiles-rc.d/wayland-fix.json".source =
    pkgs.writeTextFile
      {
        name = "nvidia-wayland-fix.json";
        text = nvidiaProfile;
      };

  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;
  programs.steam.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  services.usbmuxd.enable = true;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };
  services.openssh.enable = true;
}
