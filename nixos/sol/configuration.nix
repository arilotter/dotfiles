{pkgs, ...}: {
  imports = [
    ./samba.nix
    ./navidrome.nix
    ./digitalocean-dynamic-dns.nix # todo make it work...
    ./slskd.nix
    # TODO pihole
    # TODO music UI
    # TODO vaultwarden
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "arilotter@gmail.com";
  };

  networking = {
    hostName = "sol";

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # ssh
        80 # http
        443 # https
        445 # smb
        139 # netbios
        5030 # slskd
        7777 #
      ];
      allowedUDPPorts = [
        137
        138
        139 # netbios
        7777 # game server
      ];
    };
  };
  environment.systemPackages = [
    pkgs.steamcmd
  ];

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
  };

  services.openssh.enable = true;

  users.users.ari.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIL+5IDeIKvYpQllVsU/soRu27KyPTA5FXvZM5Z8+ms7 arilotter@gmail.com" # desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMKaPWTrDp1sp3NUXiM/JXKfivQQ6TLxMy7Fyaq59L7y arilotter@gmail.com" # laptop
  ];

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
