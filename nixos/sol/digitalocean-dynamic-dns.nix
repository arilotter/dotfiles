{pkgs, ...}: let
  ddns = pkgs.writeShellScriptBin "ddns" (builtins.readFile ./ddns.sh);
in {
  systemd.services.ddns = {
    enable = true;
    description = "Dynamic DNS Updater";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${ddns}";
      Restart = "on-failure";
      Environment = [
        "DIGITALOCEAN_TOKEN_FILE=/home/sol/digitalocean-token"
        "DOMAIN=ari.computer"
        "NAME=home"
      ];
    };
  };
}
