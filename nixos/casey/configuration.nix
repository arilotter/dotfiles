{ pkgs, ... }:
{
  imports = [
    ./immich.nix
    ./home-assistant.nix
  ];

  networking = {
    hostName = "casey";

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # ssh
      ];
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  services.openssh.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
}
